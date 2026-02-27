/* ============================================================
   iCanteen — Application Logic
   ============================================================ */

// ---- Data Store ----
const APP = {
    credit: 0.0,
    currentDate: new Date(),
    selectedDay: new Date(),
    weekOffset: 0,
    serverUrl: '',
    deviceToken: localStorage.getItem('icanteen_token') || Array.from(crypto.getRandomValues(new Uint8Array(16))).map(b => b.toString(16).padStart(2, '0')).join('')
};

window.__androidCallbacks = {};
window.handleAndroidResponse = (callbackId, base64Payload) => {
    if (window.__androidCallbacks[callbackId]) {
        try {
            // JS standard atob() doesn't handle full UTF-8 well if it contains high bytes.
            // Using a properly decoded escape sequence solves it safely.
            const decodedStr = decodeURIComponent(escape(atob(base64Payload)));
            window.__androidCallbacks[callbackId].resolve(decodedStr);
        } catch (e) {
            window.__androidCallbacks[callbackId].reject(e);
        }
        delete window.__androidCallbacks[callbackId];
    }
};

if (!localStorage.getItem('icanteen_token')) {
    localStorage.setItem('icanteen_token', APP.deviceToken);
}

// Localized day/month names per language
const DAYS = {
    cs: ['Ne', 'Po', 'Út', 'St', 'Čt', 'Pá', 'So'],
    en: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    uk: ['Нд', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб']
};
const MONTHS = {
    cs: ['Led', 'Úno', 'Bře', 'Dub', 'Kvě', 'Čer', 'Čec', 'Srp', 'Zář', 'Říj', 'Lis', 'Pro'],
    en: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    uk: ['Січ', 'Лют', 'Бер', 'Кві', 'Тра', 'Чер', 'Лип', 'Сер', 'Вер', 'Жов', 'Лис', 'Гру']
};
const DATE_LOCALES = { cs: 'cs-CZ', en: 'en-US', uk: 'uk-UA' };

// Global storage for downloaded real data
let MEALS_DATA = {}; // Keyed by YYYY-MM-DD
let PRICE_CACHE = {}; // Map meal name -> price
const ORDERS_DATA = [];
const BURZA_DATA = [];

function getLang() {
    return localStorage.getItem('icanteen_lang') || 'cs';
}
function getDays() { return DAYS[getLang()] || DAYS.cs; }
function getMonths() { return MONTHS[getLang()] || MONTHS.cs; }
function getDateLocale() { return DATE_LOCALES[getLang()] || 'cs-CZ'; }

function isWebBrowser() {
    return typeof window.AndroidHttp === 'undefined';
}
function getProxyBase() {
    return isWebBrowser() ? 'http://127.0.0.1:8000/proxy.py' : '';
}


function setThemeColor(hex) {
    document.documentElement.style.setProperty('--accent', hex);
    localStorage.setItem('icanteen_color', hex);

    let c;
    if (/^#([A-Fa-f0-9]{3}){1,2}$/.test(hex)) {
        c = hex.substring(1).split('');
        if (c.length == 3) {
            c = [c[0], c[0], c[1], c[1], c[2], c[2]];
        }
        c = '0x' + c.join('');
        const r = (c >> 16) & 255, g = (c >> 8) & 255, b = c & 255;
        document.documentElement.style.setProperty('--accent-rgb', `${r}, ${g}, ${b}`);
    }
}

// ---- Global Loading State ----
function toggleLoading(show) {
    const bar = document.getElementById('loading-bar');
    if (bar) {
        if (show) {
            bar.classList.add('active');
        } else {
            bar.classList.remove('active');
        }
    }
}

// ---- iCanteen Client Logic ----
async function apiPost(path, bodyDate) {
    if (!APP.serverUrl) throw new Error("Server URL not set");

    const isBrowser = isWebBrowser();
    const proxyBase = getProxyBase();

    toggleLoading(true);
    try {
        let html;
        if (isBrowser) {
            const fullUrl = `${proxyBase}?action=post&url=${APP.serverUrl}&token=${APP.deviceToken}&path=${encodeURIComponent(path)}`;
            const response = await fetch(fullUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: bodyDate
            });
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            html = await response.text();
        } else if (window.AndroidHttp) {
            const fullUrl = `https://${APP.serverUrl}${path}`;
            const callbackId = 'cb_' + Math.random().toString(36).substr(2, 9) + '_' + Date.now();
            html = await new Promise((resolve, reject) => {
                window.__androidCallbacks[callbackId] = { resolve, reject };
                window.AndroidHttp.postAsync(fullUrl, bodyDate.toString(), callbackId);
            });
            if (html.startsWith("ERROR:")) throw new Error(html);
        } else {
            const fullUrl = `https://${APP.serverUrl}${path}`;
            const response = await fetch(fullUrl, {
                method: 'POST',
                credentials: 'include',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: bodyDate
            });
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            html = await response.text();
        }
        if (html.includes("přihlášení uživatele") && !path.includes("login.jsp") && !path.includes("j_spring_security_check")) {
            throw new Error("SESSION_EXPIRED");
        }
        return html;
    } finally {
        toggleLoading(false);
    }
}

async function apiGet(path) {
    if (!APP.serverUrl) throw new Error("Server URL not set");

    const isBrowser = isWebBrowser();
    const proxyBase = getProxyBase();

    toggleLoading(true);
    try {
        let html;
        if (isBrowser) {
            const fullUrl = `${proxyBase}?action=fetch&url=${APP.serverUrl}&token=${APP.deviceToken}&path=${encodeURIComponent(path)}`;
            const response = await fetch(fullUrl);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            html = await response.text();
        } else if (window.AndroidHttp) {
            const fullUrl = `https://${APP.serverUrl}${path}`;
            const callbackId = 'cb_' + Math.random().toString(36).substr(2, 9) + '_' + Date.now();
            html = await new Promise((resolve, reject) => {
                window.__androidCallbacks[callbackId] = { resolve, reject };
                window.AndroidHttp.getAsync(fullUrl, callbackId);
            });
            if (html.startsWith("ERROR:")) {
                if (html.includes("403")) throw new Error("403_FORBIDDEN");
                else throw new Error(html);
            }
        } else {
            const fullUrl = `https://${APP.serverUrl}${path}`;
            const response = await fetch(fullUrl, {
                method: 'GET',
                credentials: 'include'
            });
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            html = await response.text();
        }
        if (html.includes("přihlášení uživatele") && !path.includes("login.jsp") && !path.includes("j_spring_security_check")) {
            throw new Error("SESSION_EXPIRED");
        }
        return html;
    } finally {
        toggleLoading(false);
    }
}

function parseHtml(htmlStr) {
    const parser = new DOMParser();
    return parser.parseFromString(htmlStr, "text/html");
}

async function fetchUserSettings() {
    try {
        const html = await apiGet('/faces/secured/main.jsp?terminal=false&keyboard=false&printer=false');
        const doc = parseHtml(html);

        let rawCreditStr = "";
        let finalName = "";
        let finalEmail = "";
        let finalVs = "";

        // Attempt 1: Parse from main.jsp using DOM
        try {
            const creditSpan = doc.getElementById('Kredit');
            const kreditInclude = doc.getElementById('kreditInclude');

            if (creditSpan) rawCreditStr = creditSpan.textContent;
            else if (kreditInclude) rawCreditStr = kreditInclude.textContent;

            // Escape colons in CSS selector for querySelector, or use getElementById which doesn't need escaping
            const nameElFirst = doc.getElementById('top:status:firstName');
            const nameElLast = doc.getElementById('top:status:lastName');

            if (nameElFirst && nameElLast) {
                finalName = `${nameElFirst.textContent} ${nameElLast.textContent}`.trim();
            }

            // Fallback for Android WebView DOMParser dropping colons in IDs
            if (!finalName || finalName.trim() === '') {
                const nFirst = html.match(/id="top:status:firstName"[^>]*>([^<]+)</);
                const nLast = html.match(/id="top:status:lastName"[^>]*>([^<]+)</);
                if (nFirst && nLast) {
                    finalName = `${nFirst[1].trim()} ${nLast[1].trim()}`;
                }
            }

            if (!rawCreditStr) {
                const cMatch = html.match(/id="Kredit"[^>]*>([^<]+)</);
                if (cMatch) rawCreditStr = cMatch[1].trim();
            }

            // Alternatively look for b tags
            const bTags = doc.querySelectorAll('b');
            bTags.forEach(b => {
                const prevNode = b.previousSibling;
                if (prevNode && prevNode.nodeType === 3) { // Text node
                    const text = prevNode.textContent.toLowerCase();
                    if (text.includes('jméno:')) finalName = b.textContent.trim() + " " + finalName; // might get parts backwards, but handles basic cases
                    if (text.includes('příjmení:')) finalName = finalName + " " + b.textContent.trim();
                    if (text.includes('variabilní symbol:')) finalVs = b.textContent.trim();
                }
            });
            finalName = finalName.trim().replace(/\s+/g, ' ');

            // Find email in input fields
            const inputs = doc.querySelectorAll('input[type="text"]');
            inputs.forEach(input => {
                if (input.value && input.value.includes('@')) {
                    finalEmail = input.value;
                }
            });

        } catch (e) {
            console.error("DOM parsing failed:", e);
        }

        // Attempt 2: Overwrite with historie.jsp if it succeeds
        if (!rawCreditStr || !finalName) {
            try {
                const htmlHist = await apiGet('/faces/secured/historie.jsp');
                const docHist = parseHtml(htmlHist);

                // Usually credit is bold in historie
                const bTags = docHist.querySelectorAll('b');
                bTags.forEach(b => {
                    const prevNode = b.previousSibling;
                    if (prevNode && prevNode.nodeType === 3) { // Text node
                        const text = prevNode.textContent.toLowerCase();
                        if (text.includes('zůstatek') && b.textContent.includes('Kč')) {
                            rawCreditStr = b.textContent;
                        }
                        if (text.includes('jméno:') || text.includes('jm :')) {
                            finalName = b.textContent.trim();
                        }
                    }
                });
            } catch (e) {
                console.error("Failed to parse profile from historie", e);
            }
        }

        // Apply
        if (rawCreditStr) {
            const cleanCredit = rawCreditStr.replace(/Kč|\s|&nbsp;/g, '').replace(/,/g, '.');
            const match = cleanCredit.match(/([-]?\d+(\.\d+)?)/);
            if (match) {
                APP.credit = parseFloat(match[1]) || 0;
                updateCreditDisplay();
            }
        }

        if (!finalName || finalName.length < 3 || finalName.includes('???')) finalName = t('user_default', 'Uživatel iCanteen');

        const safeSet = (id, val) => { const el = $('#' + id); if (el) el.textContent = val; };
        safeSet('sidebar-name', finalName.substring(0, 30));
        safeSet('credit-stravnik', finalName.substring(0, 30));
        safeSet('setting-name', finalName.substring(0, 30));
        safeSet('sidebar-avatar', finalName !== 'Uživatel iCanteen' ? finalName.substring(0, 2).toUpperCase() : 'IC');
        safeSet('setting-email', finalEmail || t('not_specified', 'Neuvedeno'));
        safeSet('credit-vs', finalVs || t('not_specified', 'Neuvedeno'));

    } catch (e) {
        console.error("Failed to fetch settings:", e);
        showToast("Chyba přístupu k nastavení: " + e.message, "error");
    }
}


// ---- DOM Refs ----
const $ = (sel) => document.querySelector(sel);
const $$ = (sel) => document.querySelectorAll(sel);

// ---- Init ----
document.addEventListener('DOMContentLoaded', () => {
    initParticles();
    initRipples();
    initLogin();
    initNavigation();
    initBottomNav();
    initSidebar();
    initWeekNav();
    initMeals();
    initBurza();
    initKonto();
    initSettings();
    updateDate();
});

// ============================================================
// VISUAL EFFECTS
// ============================================================

// ---- Particle System (Login Background) ----
function initParticles() {
    const canvas = document.getElementById('login-particles');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    let particles = [];
    let animId = null;
    const PARTICLE_COUNT = 50;

    function resize() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }

    function createParticle() {
        return {
            x: Math.random() * canvas.width,
            y: Math.random() * canvas.height,
            vx: (Math.random() - 0.5) * 0.3,
            vy: (Math.random() - 0.5) * 0.3,
            radius: Math.random() * 1.5 + 0.5,
            opacity: Math.random() * 0.4 + 0.1,
        };
    }

    function init() {
        resize();
        particles = [];
        for (let i = 0; i < PARTICLE_COUNT; i++) {
            particles.push(createParticle());
        }
        animate();
    }

    const isLight = document.body.classList.contains('light-mode');
    const accentRgb = getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim() || '57, 255, 20';

    particles.forEach(p => {
        p.x += p.vx;
        p.y += p.vy;

        // Wrap around
        if (p.x < 0) p.x = canvas.width;
        if (p.x > canvas.width) p.x = 0;
        if (p.y < 0) p.y = canvas.height;
        if (p.y > canvas.height) p.y = 0;

        ctx.beginPath();
        ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
        ctx.fillStyle = isLight
            ? `rgba(${accentRgb}, ${p.opacity * 1.5})`
            : `rgba(${accentRgb}, ${p.opacity})`;
        ctx.fill();
    });

    // Draw connections
    for (let i = 0; i < particles.length; i++) {
        for (let j = i + 1; j < particles.length; j++) {
            const dx = particles[i].x - particles[j].x;
            const dy = particles[i].y - particles[j].y;
            const dist = Math.sqrt(dx * dx + dy * dy);

            if (dist < 120) {
                const isLightConn = document.body.classList.contains('light-mode');
                ctx.beginPath();
                ctx.moveTo(particles[i].x, particles[i].y);
                ctx.lineTo(particles[j].x, particles[j].y);
                const isLightConn = document.body.classList.contains('light-mode');
                const accentRgb = getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim() || '57, 255, 20';
                ctx.strokeStyle = isLightConn
                    ? `rgba(${accentRgb}, ${0.12 * (1 - dist / 120)})`
                    : `rgba(${accentRgb}, ${0.06 * (1 - dist / 120)})`;
                ctx.lineWidth = 0.5;
                ctx.stroke();
            }
        }
    }

    animId = requestAnimationFrame(animate);
}

window.addEventListener('resize', resize);
init();

// Stop particles when login screen is hidden
const observer = new MutationObserver(() => {
    const loginScreen = document.getElementById('login-screen');
    if (loginScreen && !loginScreen.classList.contains('active')) {
        cancelAnimationFrame(animId);
    }
});
observer.observe(document.getElementById('login-screen'), { attributes: true, attributeFilter: ['class'] });
}

// ---- Ripple Effect ----
function initRipples() {
    document.addEventListener('click', (e) => {
        const host = e.target.closest('.ripple-host');
        if (!host) return;

        const rect = host.getBoundingClientRect();
        const ripple = document.createElement('span');
        ripple.classList.add('ripple');

        const size = Math.max(rect.width, rect.height) * 2;
        ripple.style.width = ripple.style.height = size + 'px';
        ripple.style.left = (e.clientX - rect.left - size / 2) + 'px';
        ripple.style.top = (e.clientY - rect.top - size / 2) + 'px';

        host.appendChild(ripple);
        ripple.addEventListener('animationend', () => ripple.remove());
    });
}

// ---- Confetti Micro-animation ----
function spawnConfetti(x, y) {
    const colors = ['#39FF14', '#00ff88', '#00D2FF', '#FBBF24', '#fff'];
    const count = 12;

    for (let i = 0; i < count; i++) {
        const piece = document.createElement('div');
        piece.classList.add('confetti-piece');
        piece.style.left = x + 'px';
        piece.style.top = y + 'px';
        piece.style.background = colors[Math.floor(Math.random() * colors.length)];
        piece.style.transform = `rotate(${Math.random() * 360}deg)`;

        const angle = (Math.PI * 2 * i) / count;
        const velocity = 40 + Math.random() * 40;
        const dx = Math.cos(angle) * velocity;
        const dy = Math.sin(angle) * velocity;

        piece.style.setProperty('--dx', dx + 'px');
        piece.style.setProperty('--dy', dy + 'px');

        // Custom animation with random spread
        piece.animate([
            { transform: `translate(0, 0) rotate(0deg) scale(1)`, opacity: 1 },
            { transform: `translate(${dx}px, ${dy - 30}px) rotate(${360 + Math.random() * 360}deg) scale(0)`, opacity: 0 }
        ], {
            duration: 700 + Math.random() * 300,
            easing: 'cubic-bezier(.22, 1, .36, 1)',
            fill: 'forwards'
        });

        document.body.appendChild(piece);
        setTimeout(() => piece.remove(), 1200);
    }
}

// ---- Staggered Card Reveal ----
function revealCards(container, selector) {
    const cards = container.querySelectorAll(selector);
    cards.forEach((card, i) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        setTimeout(() => {
            card.classList.add('reveal');
            card.style.opacity = '';
            card.style.transform = '';
        }, i * 60);
    });
}


// ============================================================
// LOGIN
// ============================================================
function initLogin() {
    const form = $('#login-form');
    const loginScreen = $('#login-screen');
    const appScreen = $('#app-screen');

    // Load from localStorage
    const savedServer = localStorage.getItem('icanteen_server');
    const savedUser = localStorage.getItem('icanteen_user');
    const savedPass = localStorage.getItem('icanteen_pass');

    if (savedServer) $('#server-url').value = savedServer;
    if (savedUser) $('#username').value = savedUser;
    if (savedPass) $('#password').value = savedPass;

    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        const btn = $('#btn-login');
        const originalHtml = btn.innerHTML;

        // Add spin animation
        if (!document.querySelector('#spin-style')) {
            const style = document.createElement('style');
            style.id = 'spin-style';
            style.textContent = '@keyframes spin { to { transform: rotate(360deg) } }';
            document.head.appendChild(style);
        }

        btn.innerHTML = `<span class="material-symbols-rounded" style="animation:spin 1s linear infinite">progress_activity</span> ${t('login.logging_in', 'Přihlašování...')}`;
        btn.style.pointerEvents = 'none';

        const url = $('#server-url').value.trim();
        const user = $('#username').value.trim();
        const pass = $('#password').value.trim();

        try {
            const isBrowser = isWebBrowser();
            const proxyBase = getProxyBase();

            let success = false;

            if (isBrowser) {
                const bodyDate = new URLSearchParams();
                bodyDate.append('user', user);
                bodyDate.append('pass', pass);

                const response = await fetch(`${proxyBase}?action=login&url=${url}&token=${APP.deviceToken}`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: bodyDate
                });

                const data = await response.json();
                if (data.success) {
                    success = true;
                } else {
                    throw new Error(data.error || 'Proxy login failed');
                }
            } else if (window.AndroidHttp) {
                // Async Preflight
                const preflightUrl = `https://${url}/faces/login.jsp`;
                const cbPre = 'cb_' + Math.random().toString(36).substr(2, 9) + '_' + Date.now();
                const preflightHtml = await new Promise((resolve, reject) => {
                    window.__androidCallbacks[cbPre] = { resolve, reject };
                    window.AndroidHttp.getAsync(preflightUrl, cbPre);
                });
                const doc = parseHtml(preflightHtml);

                let csrfToken = '';
                const csrfInput = doc.querySelector('input[name="_csrf"]');
                if (csrfInput) csrfToken = csrfInput.value;

                const loginUrl = `https://${url}/j_spring_security_check`;
                const bodyDate = new URLSearchParams();
                bodyDate.append('j_username', user);
                bodyDate.append('j_password', pass);
                bodyDate.append('terminal', 'false');
                if (csrfToken) bodyDate.append('_csrf', csrfToken);

                const cbLogin = 'cb_' + Math.random().toString(36).substr(2, 9) + '_' + Date.now();
                const loginHtml = await new Promise((resolve, reject) => {
                    window.__androidCallbacks[cbLogin] = { resolve, reject };
                    window.AndroidHttp.postAsync(loginUrl, bodyDate.toString(), cbLogin);
                });

                if (loginHtml.startsWith("ERROR: HTTP 403")) {
                    throw new Error("Invalid credentials");
                } else if (loginHtml.startsWith("ERROR:")) {
                    throw new Error(loginHtml);
                } else {
                    success = true;
                }
            } else {
                const preflightRes = await fetch(`https://${url}/faces/login.jsp`, { credentials: 'include' });
                const preflightHtml = await preflightRes.text();
                const doc = parseHtml(preflightHtml);

                let csrfToken = '';
                const csrfInput = doc.querySelector('input[name="_csrf"]');
                if (csrfInput) csrfToken = csrfInput.value;

                const loginUrl = `https://${url}/j_spring_security_check`;
                const bodyDate = new URLSearchParams();
                bodyDate.append('j_username', user);
                bodyDate.append('j_password', pass);
                bodyDate.append('terminal', 'false');
                if (csrfToken) bodyDate.append('_csrf', csrfToken);

                const response = await fetch(loginUrl, {
                    method: 'POST',
                    credentials: 'include',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: bodyDate
                });
                if (!response.url.includes('error?code=403')) success = true;
            }

            if (success) {
                localStorage.setItem('icanteen_server', url);
                localStorage.setItem('icanteen_user', user);
                localStorage.setItem('icanteen_pass', pass);

                APP.serverUrl = url;

                // Smooth transition to app
                loginScreen.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                loginScreen.style.opacity = '0';
                loginScreen.style.transform = 'scale(1.05)';

                setTimeout(() => {
                    loginScreen.classList.remove('active');
                    loginScreen.style.opacity = '';
                    loginScreen.style.transform = '';
                    appScreen.classList.add('active');
                    showToast(t('login.success', 'Přihlášení úspěšné!'), 'check_circle');

                    fetchRealMeals();
                }, 500);
            } else {
                throw new Error("Invalid credentials or server rejected login");
            }

        } catch (err) {
            console.error('Login Error:', err);
            btn.innerHTML = originalHtml;
            btn.style.pointerEvents = '';

            // Shake animation on error
            const card = $('.login-card');
            card.style.animation = 'none';
            card.offsetHeight; // trigger reflow
            card.style.animation = 'shake 0.5s ease';
            setTimeout(() => card.style.animation = '', 600);

            showToast(t('login.error', 'Chyba přihlášení'), 'error');
        }
    });

    $('#btn-logout').addEventListener('click', async () => {
        const btn = $('#btn-logout');
        btn.style.pointerEvents = 'none';

        try {
            await apiGet('/j_spring_security_logout');
        } catch (e) {
            console.log("Logout request failed or offline", e);
        }

        localStorage.removeItem('icanteen_pass');
        $('#password').value = '';

        $('#app-screen').classList.remove('active');
        $('#login-screen').classList.add('active');

        const loginBtn = $('#btn-login');
        loginBtn.innerHTML = `<span>${t('login.login', 'Přihlásit se')}</span><span class="material-symbols-rounded">arrow_forward</span>`;
        loginBtn.style.pointerEvents = '';
        btn.style.pointerEvents = '';

        // Restart particles
        initParticles();
    });

    // Add shake keyframes
    if (!document.querySelector('#shake-style')) {
        const style = document.createElement('style');
        style.id = 'shake-style';
        style.textContent = `
            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                20% { transform: translateX(-12px); }
                40% { transform: translateX(10px); }
                60% { transform: translateX(-6px); }
                80% { transform: translateX(4px); }
            }
        `;
        document.head.appendChild(style);
    }
}

// ============================================================
// SCRAPE DAILY MEALS
// ============================================================
async function fetchRealMeals() {
    try {
        const promises = [];
        const dateMapping = [];

        // Fetch 4 weeks data (offset 0 = current week, to 3)
        for (let offset = 0; offset < 4; offset++) {
            const days = getWeekDays(offset);
            for (const d of days) {
                const year = d.getFullYear();
                const month = String(d.getMonth() + 1).padStart(2, '0');
                const day = String(d.getDate()).padStart(2, '0');
                const urlParams = `?day=${year}-${month}-${day}&terminal=false&printer=false&keyboard=false`;

                promises.push(apiGet(`/faces/secured/main.jsp${urlParams}`));
                dateMapping.push(d);
            }
        }

        const htmlResults = await Promise.all(promises);

        MEALS_DATA = {};
        PRICE_CACHE = {};

        htmlResults.forEach((html, i) => {
            const d = dateMapping[i];
            const dateStr = formatDateISO(d);
            const doc = parseHtml(html);
            MEALS_DATA[dateStr] = parseMealDay(doc);
        });

        renderMeals();
        updateDate();
    } catch (e) {
        console.error("Failed to parse meals:", e);
        if (e.message === "SESSION_EXPIRED") {
            showToast(t('session_expired', 'Platnost relace vypršela. Přihlaste se prosím znovu.'), 'error');
            const logoutBtn = $('#btn-logout');
            if (logoutBtn) logoutBtn.click();
        } else {
            showToast(t('meals_load_error', 'Nepodařilo se načíst obědy'), 'error');
        }
    }
}

function parseMealDay(doc) {
    const mealBlocks = doc.querySelectorAll('.jidelnicekItemWrapper');
    let localIdCounter = 1;
    const meals = [];

    mealBlocks.forEach(wrapper => {
        const rawText = wrapper.textContent || "";
        const canOrder = !(rawText.includes('nelze zrušit') || rawText.includes('nelze objednat') || rawText.includes('nelze změnit'));
        const isOrdered = rawText.includes('Máte objednáno') || rawText.includes('zrušit objednávku') || rawText.includes('odhlásit');

        let price = 0;
        const priceEl = wrapper.querySelector('.jidWrapLeft .important.warning');
        if (priceEl) {
            const pText = priceEl.textContent.trim().replace(',', '.');
            price = parseFloat(pText) || 0;
        }

        let jidloJmeno = "";
        let allergens = [];
        const centerEl = wrapper.querySelector('.jidWrapCenter');

        if (centerEl) {
            const subNode = centerEl.querySelector('sub');
            if (subNode) {
                const allergenSpans = subNode.querySelectorAll('.textGrey');
                allergenSpans.forEach(span => {
                    const parts = span.textContent.split(',');
                    parts.forEach(p => {
                        const n = parseInt(p.trim());
                        if (!isNaN(n) && !allergens.includes(n)) {
                            allergens.push(n);
                        }
                    });
                });

                const clone = centerEl.cloneNode(true);
                const cloneSub = clone.querySelector('sub');
                if (cloneSub) clone.removeChild(cloneSub);
                jidloJmeno = clone.textContent.replace(/\n|  /g, '').trim();
            } else {
                jidloJmeno = centerEl.textContent.replace(/\n|  /g, '').trim();
            }
        }

        let orderUrl = null;
        let burzaUrl = null;

        const checkUrls = (htmlStr) => {
            if (canOrder) {
                const orderMatch = htmlStr.match(/ajaxOrder\(this,\s*'(.+?)'/);
                if (orderMatch && orderMatch[1]) orderUrl = orderMatch[1].replace(/&amp;/g, '&');
            } else {
                const burzaMatch = htmlStr.match(/db\/dbProcessOrder\.jsp.+?type=(?:plusburza|minusburza|multiburza).+?'/);
                if (burzaMatch) burzaUrl = burzaMatch[0].replace(/'$/, '').replace(/&amp;/g, '&');
            }
        };

        const btnEl = wrapper.querySelector('.jidWrapLeft a.btn');
        if (btnEl && btnEl.getAttribute('onclick')) checkUrls(btnEl.getAttribute('onclick'));
        else if (wrapper.innerHTML.includes('db/dbProcessOrder.jsp')) checkUrls(wrapper.innerHTML);

        const nameClean = jidloJmeno.split(',')[0] || jidloJmeno;
        if (jidloJmeno.length > 5) {
            let deadline = '??:??';
            const clockIcon = wrapper.querySelector('.jidWrapRight .fa-clock');
            if (clockIcon && clockIcon.getAttribute('title')) {
                const titleMatch = clockIcon.getAttribute('title').match(/do:\s*<b>(.+?)<\/b>/);
                if (titleMatch && titleMatch[1]) deadline = titleMatch[1];
            }

            meals.push({
                id: localIdCounter++,
                number: localIdCounter - 1,
                name: nameClean,
                description: jidloJmeno,
                price: price,
                allergens: allergens,
                ordered: isOrdered,
                deadline: deadline,
                orderUrl: orderUrl,
                burzaUrl: burzaUrl,
                canOrder: canOrder
            });

            if (price > 0 && nameClean) {
                PRICE_CACHE[nameClean.trim().substring(0, 30)] = price;
            }
        }
    });

    return meals;
}

// ============================================================
// NAVIGATION
// ============================================================
function navigateToPage(pageName) {
    // Update sidebar nav
    $$('.nav-item').forEach(n => n.classList.remove('active'));
    const sidebarItem = $(`.nav-item[data-page="${pageName}"]`);
    if (sidebarItem) sidebarItem.classList.add('active');

    // Update bottom nav
    $$('.bottom-nav-item').forEach(n => n.classList.remove('active'));
    const bottomItem = $(`.bottom-nav-item[data-page="${pageName}"]`);
    if (bottomItem) bottomItem.classList.add('active');

    // Switch pages
    $$('.page').forEach(p => p.classList.remove('active'));
    const targetPage = $(`#page-${pageName}`);
    if (targetPage) targetPage.classList.add('active');

    // Update title
    const titleKeys = {
        jidelnicek: 'page.menu',
        objednavky: 'page.orders',
        burza: 'page.burza',
        konto: 'page.konto',
        nastaveni: 'page.settings'
    };
    const titleKey = titleKeys[pageName];
    $('#page-title').textContent = titleKey ? t(titleKey, pageName) : pageName;

    // Close sidebar on mobile
    if (window.innerWidth <= 768) {
        $('#sidebar').classList.remove('open');
        $('#sidebar-overlay').classList.remove('active');
    }
}

function initNavigation() {
    const navItems = $$('.nav-item');
    navItems.forEach(item => {
        item.addEventListener('click', () => {
            navigateToPage(item.dataset.page);
        });
    });
}

function initBottomNav() {
    const bottomItems = $$('.bottom-nav-item');
    bottomItems.forEach(item => {
        item.addEventListener('click', () => {
            navigateToPage(item.dataset.page);
        });
    });
}

// ---- Sidebar ----
function initSidebar() {
    const toggle = $('#sidebar-toggle');
    const sidebar = $('#sidebar');
    const overlay = $('#sidebar-overlay');

    if (toggle) {
        toggle.addEventListener('click', () => {
            sidebar.classList.toggle('open');
            overlay.classList.toggle('active');
        });
    }

    if (overlay) {
        overlay.addEventListener('click', () => {
            sidebar.classList.remove('open');
            overlay.classList.remove('active');
        });
    }
}

// ---- Date ----
function updateDate() {
    const now = new Date();
    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    $('#current-date').textContent = now.toLocaleDateString(getDateLocale(), options);
}

function getWeekDays(offset = 0) {
    const now = new Date();
    const monday = new Date(now);
    const day = monday.getDay();
    const diff = monday.getDate() - day + (day === 0 ? -6 : 1) + (offset * 7);
    monday.setDate(diff);

    const days = [];
    for (let i = 0; i < 5; i++) {
        const d = new Date(monday);
        d.setDate(monday.getDate() + i);
        days.push(d);
    }
    return days;
}

function formatDateISO(d) {
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

function isSameDay(a, b) {
    return a.getDate() === b.getDate() &&
        a.getMonth() === b.getMonth() &&
        a.getFullYear() === b.getFullYear();
}

// ---- Week Navigation ----
function initWeekNav() {
    renderWeekDays();

    $('#prev-week').addEventListener('click', () => {
        APP.weekOffset--;
        renderWeekDays();
        renderMeals();
    });

    $('#next-week').addEventListener('click', () => {
        APP.weekOffset++;
        renderWeekDays();
        renderMeals();
    });
}

function renderWeekDays() {
    const container = $('#week-days');
    const days = getWeekDays(APP.weekOffset);

    container.innerHTML = days.map((d, i) => {
        const isToday = isSameDay(d, new Date());
        const isSelected = isSameDay(d, APP.selectedDay);
        const classes = ['day-btn'];
        if (isToday) classes.push('today');
        if (isSelected) classes.push('active');

        return `
            <button class="${classes.join(' ')}" data-index="${i}" data-date="${d.toISOString()}">
                <span class="day-name">${getDays()[d.getDay()]}</span>
                <span class="day-number">${d.getDate()}</span>
                <span class="day-month">${getMonths()[d.getMonth()]}</span>
            </button>
        `;
    }).join('');

    container.querySelectorAll('.day-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            container.querySelectorAll('.day-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            APP.selectedDay = new Date(btn.dataset.date);
            renderMeals();
        });
    });
}

// ============================================================
// MEALS
// ============================================================
function initMeals() {
    renderMeals();
}

function renderMeals() {
    const container = $('#meals-container');
    const dateStr = formatDateISO(APP.selectedDay);

    if (!MEALS_DATA[dateStr] || MEALS_DATA[dateStr].length === 0) {
        container.innerHTML = `
            <div style="text-align:center; padding:60px 20px; color:var(--text-muted);">
                <span class="material-symbols-rounded" style="font-size:56px; display:block; margin-bottom:14px; opacity:.5;">weekend</span>
                <p style="font-size:15px; font-weight:600;">${t('meals.no_meals', 'V tento den se nevaří')}</p>
            </div>
        `;
        return;
    }

    const meals = MEALS_DATA[dateStr];
    container.innerHTML = meals.map((meal, i) => `
        <div class="meal-card ${meal.ordered ? 'ordered' : ''}" data-meal-id="${meal.id}">
            <div class="meal-number">${meal.number}</div>
            <div class="meal-info">
                <div class="meal-name">${meal.name}</div>
                <div class="meal-description">${meal.description}</div>
                <div class="meal-tags">
                    <span class="meal-tag">
                        <span class="material-symbols-rounded">restaurant</span>
                        ${t('meals.lunch', 'Oběd')} ${meal.number}
                    </span>
                    ${meal.allergens.map(a => `
                        <span class="meal-tag allergen-tag">
                            <span class="material-symbols-rounded">warning</span>
                            ${a}
                        </span>
                    `).join('')}
                </div>
            </div>
            <div class="meal-actions">
                <div class="meal-price">${meal.price} Kč</div>
                <div class="meal-ordered-badge"><span class="pulse-dot"></span> ${t('meals.ordered_badge', 'Objednáno')}</div>
                ${(meal.canOrder || meal.ordered) ? `
                <button class="btn-order ripple-host ${meal.ordered ? 'ordered' : ''}" data-meal-id="${meal.id}">
                    <span class="material-symbols-rounded">${meal.ordered ? 'check_circle' : 'add_shopping_cart'}</span>
                    <span class="btn-order-text">${t('meals.order', 'Objednat')}</span>
                    <span class="btn-order-text-cancel">${t('meals.cancel', 'Odhlásit')}</span>
                </button>
                ` : `
                <button class="btn-order disabled" disabled style="background:var(--bg-card); border:1px solid rgba(0,0,0,0.1); color:var(--text-muted); cursor:not-allowed;">
                    <span class="material-symbols-rounded">block</span>
                    <span class="btn-order-text" style="opacity: 0.8">${t('meals.cannot_order', 'Nelze objednat')}</span>
                </button>
                `}

                <div class="meal-deadline">
                    <span class="material-symbols-rounded">schedule</span>
                    ${t('meals.deadline_prefix', 'do')} ${meal.deadline}
                </div>
            </div>
        </div>
    `).join('');

    // Staggered reveal
    revealCards(container, '.meal-card');

    // Attach order handlers
    container.querySelectorAll('.btn-order').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const mealId = parseInt(btn.dataset.mealId);
            toggleOrder(mealId, e);
        });
    });
}

async function toggleOrder(mealId, event) {
    let targetMeal = null;
    for (const ds of Object.keys(MEALS_DATA)) {
        const found = MEALS_DATA[ds].find(m => m.id === mealId);
        if (found) { targetMeal = found; break; }
    }

    if (!targetMeal) return;

    const path = targetMeal.orderUrl || targetMeal.burzaUrl;
    if (!path) {
        showToast(t('meals.cannot_edit', 'Toto jídlo nelze upravit'), 'error');
        return;
    }

    try {
        await apiGet(`/faces/secured/${path}`);

        targetMeal.ordered = !targetMeal.ordered;
        if (targetMeal.ordered) {
            APP.credit -= targetMeal.price;
            showToast(`${targetMeal.name} — ${t('meals.ordered_toast', 'objednáno')}`, 'check_circle');

            // Confetti on order!
            if (event) {
                const rect = event.target.getBoundingClientRect();
                spawnConfetti(rect.left + rect.width / 2, rect.top);
            }
        } else {
            APP.credit += targetMeal.price;
            showToast(`${targetMeal.name} — ${t('meals.cancelled_toast', 'odhlášeno')}`, 'remove_shopping_cart');
        }

        updateCreditDisplay();
        renderMeals();

        // Refetch quietly to ensure consistency
        fetchRealMeals();
        fetchUserSettings();
    } catch (e) {
        showToast(t('comm_error', 'Chyba při komunikaci'), 'error');
    }
}

function updateCreditDisplay() {
    const formatted = APP.credit.toLocaleString('cs-CZ') + ' Kč';
    const el1 = $('#credit-amount');
    const el2 = $('#credit-value');

    const elements = [el1, el2].filter(el => el !== null);
    elements.forEach(el => {
        el.textContent = formatted;
        if (APP.credit < 0) {
            el.style.color = 'var(--error)';
        } else {
            el.style.color = '';
        }
    });
}

// ============================================================
// KONTO (Objednávky + Kredit)
// ============================================================
function initKonto() {
    document.querySelector('[data-page="konto"]').addEventListener('click', fetchOrderHistory);
    updateCreditDisplay();
    renderOrders();
}

async function fetchOrderHistory() {
    try {
        const htmlObj = await apiGet('/faces/secured/objednavky.jsp?status=false');
        const docObj = parseHtml(htmlObj);

        const htmlHist = await apiGet('/faces/secured/historie.jsp?status=false');
        const docHist = parseHtml(htmlHist);

        ORDERS_DATA.length = 0;

        const parseTableRows = (doc, isHistory) => {
            const rows = doc.querySelectorAll('tr');
            const parseDate = (dStr) => {
                const parts = dStr.split('.');
                if (parts.length >= 3) return new Date(parseInt(parts[2]), parseInt(parts[1]) - 1, parseInt(parts[0]));
                return new Date();
            };

            rows.forEach(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length >= 3) {
                    const dateText = (cells[0].textContent || "").trim();
                    const descText = (cells[1].textContent || "").trim();
                    const priceText = (cells[2].textContent || "").replace(',', '.').trim();

                    if (dateText.match(/^\d{1,2}\.\d{1,2}\.\d{4}/) && descText) {
                        const mealDateObj = parseDate(dateText);
                        const price = parseFloat(priceText) || 0;
                        const mealName = descText.split(/[-;]/)[0].trim();

                        let status = isHistory ? 'eaten' : 'ordered';
                        if (descText.toLowerCase().includes('storno') || descText.toLowerCase().includes('zruš')) {
                            status = 'cancelled';
                        }

                        ORDERS_DATA.push({
                            date: mealDateObj,
                            meal: mealName,
                            type: t('meals.lunch', 'Oběd'),
                            status: status,
                            price: Math.abs(price)
                        });
                    }
                }
            });
        };

        parseTableRows(docObj, false);
        parseTableRows(docHist, true);

        ORDERS_DATA.sort((a, b) => b.date - a.date);
        renderOrders();
    } catch (e) {
        console.error("Orders fetch failed:", e);
        ORDERS_DATA.length = 0;
        const listCurrent = $('#current-orders-list');
        const listHistory = $('#history-orders-list');
        if (listCurrent) listCurrent.innerHTML = `<div style="padding: 20px; text-align: center; color: var(--error); font-weight: 500;">Chyba při načítání objednávek: ${e.message}</div>`;
        if (listHistory) listHistory.innerHTML = `<div style="padding: 20px; text-align: center; color: var(--error); font-weight: 500;">Chyba při načítání historie: ${e.message}</div>`;
    }
}

function renderOrders() {
    const listCurrent = $('#current-orders-list');
    const listHistory = $('#history-orders-list');
    const statusLabels = { ordered: t('status.ordered', 'Objednáno'), eaten: t('status.eaten', 'Odebráno'), cancelled: t('status.cancelled', 'Odhlášeno') };
    const statusIcons = { ordered: 'check_circle', eaten: 'restaurant', cancelled: 'cancel' };

    if (!listCurrent || !listHistory) return;

    if (ORDERS_DATA.length === 0) {
        listCurrent.innerHTML = `<div style="padding: 20px; text-align: center; color: var(--text-muted); font-weight: 500;">${t('orders.loading', 'Načítám aktuální objednávky…')}</div>`;
        listHistory.innerHTML = `<div style="padding: 20px; text-align: center; color: var(--text-muted); font-weight: 500;">${t('history.loading', 'Načítám historii…')}</div>`;
        return;
    }

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const currentOrders = ORDERS_DATA.filter(o => o.date >= today);
    const historyOrders = ORDERS_DATA.filter(o => o.date < today);

    const mapFn = (order) => `
        <div class="order-item" data-reveal>
            <div class="order-date">
                <span class="order-date-day">${order.date.getDate()}</span>
                <span class="order-date-month">${getMonths()[order.date.getMonth()]}</span>
            </div>
            <div class="order-info">
                <div class="order-meal-name">${order.meal}</div>
                <div class="order-meal-type">${order.type}</div>
            </div>
            <div class="order-status status-${order.status}">
                <span class="material-symbols-rounded" style="font-size:14px">${statusIcons[order.status]}</span>
                ${statusLabels[order.status]}
            </div>
            <div class="order-price">${order.price > 0 ? order.price + ' Kč' : ''}</div>
        </div>
    `;

    listCurrent.innerHTML = currentOrders.length ? currentOrders.map(mapFn).join('') : `<div style="padding: 15px; text-align: center; color: var(--text-muted);">${t('orders.empty', 'Zatím žádné objednávky')}</div>`;
    listHistory.innerHTML = historyOrders.length ? historyOrders.map(mapFn).join('') : `<div style="padding: 15px; text-align: center; color: var(--text-muted);">${t('history.empty', 'Zatím žádná historie')}</div>`;

    revealCards(listCurrent.parentElement, '.order-item');
    revealCards(listHistory.parentElement, '.order-item');
}

// ============================================================
// BURZA
// ============================================================
function initBurza() {
    document.querySelectorAll('[data-page="burza"]').forEach(el => {
        el.addEventListener('click', fetchBurza);
    });
}

async function fetchBurza() {
    try {
        const html = await apiGet('/faces/secured/burza.jsp');
        const doc = parseHtml(html);

        BURZA_DATA.length = 0;

        const rows = doc.querySelectorAll('tr.mouseOutRow, tr:not([class])'); // usually mouseOutRow

        rows.forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length < 3) return; // Must have at least a few columns

            const getText = (el) => el.textContent.replace(/\n|  /g, '').trim();

            let dateObj = null;
            let mealName = '';
            let count = 1; // Default to 1

            // Search cells for date-like string
            for (let i = 0; i < cells.length; i++) {
                const text = getText(cells[i]);
                if (text.match(/^\d{1,2}\.\d{1,2}\.\d{4}/)) {
                    const rawDate = text.match(/^(\d{1,2})\.(\d{1,2})\.(\d{4})/);
                    dateObj = new Date(parseInt(rawDate[3]), parseInt(rawDate[2]) - 1, parseInt(rawDate[1]));

                    // Usually name comes after date
                    if (i + 1 < cells.length) mealName = getText(cells[i + 1]);
                }
                if (text.includes('ks')) {
                    count = parseInt(text.replace('ks', '').trim()) || count;
                }
            }

            if (dateObj && mealName) {
                const urlMatch = row.innerHTML.match(/db\/dbProcessOrder\.jsp[^']+/);
                let orderUrl = '';
                if (urlMatch) orderUrl = urlMatch[0].replace(/&amp;/g, '&');

                const shortName = mealName.split(',')[0].trim().substring(0, 30);
                let derivedPrice = 0;
                for (let k in PRICE_CACHE) {
                    if (k.includes(shortName) || shortName.includes(k)) {
                        derivedPrice = PRICE_CACHE[k];
                        break;
                    }
                }

                if (mealName.length > 2) {
                    BURZA_DATA.push({
                        date: dateObj,
                        meal: mealName,
                        desc: t('burza.desc', 'Jídlo k dispozici z burzy'),
                        price: derivedPrice,
                        count: count,
                        url: orderUrl
                    });
                }
            }
        });

        renderBurza();
    } catch (e) {
        console.error("Burza fetch failed:", e);
        BURZA_DATA.length = 0;
        const container = $('#burza-list');
        if (container) {
            container.innerHTML = `<div style="padding: 20px; text-align: center; color: var(--error); font-weight: 500;">Nepodařilo se načíst burzu: ${e.message}</div>`;
        }
    }
}

function renderBurza() {
    const container = $('#burza-list');

    if (BURZA_DATA.length === 0) {
        container.innerHTML = `<div style="padding: 20px; text-align: center; color: var(--text-muted); font-weight: 500;">${t('burza.empty', 'Burza je aktuálně prázdná.')}</div>`;
        return;
    }

    container.innerHTML = BURZA_DATA.map((item, i) => `
        <div class="burza-card" data-reveal>
            <div class="burza-card-header">
                <span class="burza-date">
                    <span class="material-symbols-rounded">calendar_today</span>
                    ${item.date.getDate()}. ${item.date.getMonth() + 1}. ${item.date.getFullYear()}
                </span>
                <span class="burza-badge">${item.count}× ${t('burza.available', 'dostupné')}</span>
            </div>
            <div class="burza-meal-name">${item.meal}</div>
            <div class="burza-meal-desc">${item.desc}</div>
            <div class="burza-card-footer">
                <span class="burza-price">${item.price > 0 ? item.price : '?'} Kč</span>
                <button class="btn-burza ripple-host" data-index="${i}">${t('burza.order', 'Objednat z burzy')}</button>
            </div>
        </div>
    `).join('');

    revealCards(container, '.burza-card');

    container.querySelectorAll('.btn-burza').forEach(btn => {
        btn.addEventListener('click', async () => {
            const idx = parseInt(btn.dataset.index);
            const item = BURZA_DATA[idx];
            if (item.count > 0 && item.url) {
                try {
                    await apiGet(`/${item.url}`);
                    showToast(`${item.meal} — ${t('burza.ordered_toast', 'objednáno z burzy')}`, 'swap_horiz');
                    setTimeout(fetchBurza, 500);
                } catch (e) {
                    showToast(t('burza.order_error', 'Chyba při objednávce z burzy'), 'error');
                }
            }
        });
    });
}



// ============================================================
// SETTINGS
// ============================================================
function initSettings() {
    // Theme color
    const savedColor = localStorage.getItem('icanteen_color');
    const colorBtns = document.querySelectorAll('.color-btn');

    if (savedColor) {
        setThemeColor(savedColor);
        colorBtns.forEach(b => {
            b.classList.toggle('active', b.dataset.color === savedColor);
        });
    }

    colorBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            colorBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            const newColor = btn.dataset.color;
            setThemeColor(newColor);
            showToast(t('settings_saved', 'Motiv změněn'), 'palette');
        });
    });

    // Light Mode
    const lightToggle = $('#light-mode-toggle');
    if (lightToggle) {
        const isLight = localStorage.getItem('icanteen_light_mode') === 'true';
        lightToggle.checked = isLight;
        if (isLight) document.body.classList.add('light-mode');

        lightToggle.addEventListener('change', (e) => {
            if (e.target.checked) {
                document.body.classList.add('light-mode');
                localStorage.setItem('icanteen_light_mode', 'true');
            } else {
                document.body.classList.remove('light-mode');
                localStorage.setItem('icanteen_light_mode', 'false');
            }
        });
    }

    // Language
    const langSelect = $('#lang-select');
    if (langSelect) {
        const currentLang = localStorage.getItem('icanteen_lang') || 'cs';
        langSelect.value = currentLang;
        setLanguage(currentLang);

        langSelect.addEventListener('change', (e) => {
            setLanguage(e.target.value);
            showToast(t('settings_saved', 'Jazyk změněn'), 'language');
        });
    }
}

// ============================================================
// I18N (LOKALIZACE)
// ============================================================
const translations = {
    cs: {
        'nav.jidelnicek': 'J\u00eddeln\u00ed\u010dek', 'nav.burza': 'Burza', 'nav.credit': 'Konto', 'nav.settings': 'Nastaven\u00ed',
        'page.menu': 'J\u00eddeln\u00ed\u010dek', 'page.orders': 'Objedn\u00e1vky', 'page.burza': 'Burza', 'page.konto': 'Moje Konto', 'page.settings': 'Nastaven\u00ed',
        'settings.appearance': 'Vzhled a Jazyk', 'settings.accent': 'Barva motivu', 'settings.dark_mode': 'Sv\u011btl\u00fd re\u017eim',
        'settings.language': 'Jazyk', 'settings_saved': 'Nastaven\u00ed ulo\u017eeno',
        'settings.profile': 'Profil', 'settings.name': 'Jm\u00e9no', 'settings.class': 'T\u0159\u00edda',
        'settings.email': 'E-mail', 'settings.category': 'Kategorie',
        'login.subtitle': '\u0160koln\u00ed j\u00eddelna', 'login.username': 'U\u017eivatelsk\u00e9 jm\u00e9no', 'login.password': 'Heslo',
        'login.server': 'URL serveru j\u00eddelny', 'login.login': 'P\u0159ihl\u00e1sit se', 'login.logging_in': 'P\u0159ihla\u0161ov\u00e1n\u00ed...',
        'login.success': 'P\u0159ihl\u00e1\u0161en\u00ed \u00fasp\u011b\u0161n\u00e9!', 'login.error': 'Chyba p\u0159ihl\u00e1\u0161en\u00ed',
        'credit.balance': 'Aktu\u00e1ln\u00ed z\u016fstatek', 'credit.diner': 'Str\u00e1vn\u00edk', 'credit.vs': 'Variabiln\u00ed symbol',
        'credit.current_orders': 'Aktu\u00e1ln\u00ed objedn\u00e1vky', 'credit.history': 'Historie a Platby',
        'meals.lunch': 'Ob\u011bd', 'meals.order': 'Objednat', 'meals.cancel': 'Odhl\u00e1sit', 'meals.ordered_badge': 'Objedn\u00e1no',
        'meals.deadline_prefix': 'do', 'meals.no_meals': 'V tento den se neva\u0159\u00ed',
        'meals.ordered_toast': 'objedn\u00e1no', 'meals.cancelled_toast': 'odhl\u00e1\u0161eno',
        'meals.cannot_edit': 'Toto j\u00eddlo nelze upravit', 'meals.unknown': 'Nezn\u00e1m\u00e9 j\u00eddlo',
        'orders.loading': 'Na\u010d\u00edt\u00e1m aktu\u00e1ln\u00ed objedn\u00e1vky\u2026', 'orders.empty': 'Zat\u00edm \u017e\u00e1dn\u00e9 objedn\u00e1vky',
        'history.loading': 'Na\u010d\u00edt\u00e1m historii\u2026', 'history.empty': 'Zat\u00edm \u017e\u00e1dn\u00e1 historie',
        'status.ordered': 'Objedn\u00e1no', 'status.eaten': 'Odebr\u00e1no', 'status.cancelled': 'Odhl\u00e1\u0161eno',
        'burza.empty': 'Burza je aktu\u00e1ln\u011b pr\u00e1zdn\u00e1.', 'burza.available': 'dostupn\u00e9',
        'burza.order': 'Objednat z burzy', 'burza.desc': 'J\u00eddlo k dispozici z burzy',
        'burza.ordered_toast': 'objedn\u00e1no z burzy', 'burza.order_error': 'Chyba p\u0159i objedn\u00e1vce z burzy',
        'user_default': 'U\u017eivatel iCanteen', 'not_specified': 'Neuvedeno',
        'session_expired': 'Platnost relace vypr\u0161ela. P\u0159ihlaste se pros\u00edm znovu.',
        'meals_load_error': 'Nepoda\u0159ilo se na\u010d\u00edst ob\u011bdy', 'comm_error': 'Chyba p\u0159i komunikaci',
        'notif.none': '\u017d\u00e1dn\u00e9 nov\u00e9 upozorn\u011bn\u00ed', 'loading': 'Na\u010d\u00edt\u00e1n\u00ed...',
    },
    en: {
        'nav.jidelnicek': 'Menu', 'nav.burza': 'Exchange', 'nav.credit': 'Account', 'nav.settings': 'Settings',
        'page.menu': 'Menu', 'page.orders': 'Orders', 'page.burza': 'Exchange', 'page.konto': 'My Account', 'page.settings': 'Settings',
        'settings.appearance': 'Appearance & Language', 'settings.accent': 'Theme Color', 'settings.dark_mode': 'Light Mode',
        'settings.language': 'Language', 'settings_saved': 'Settings saved',
        'settings.profile': 'Profile', 'settings.name': 'Name', 'settings.class': 'Class',
        'settings.email': 'E-mail', 'settings.category': 'Category',
        'login.subtitle': 'School Canteen', 'login.username': 'Username', 'login.password': 'Password',
        'login.server': 'Canteen server URL', 'login.login': 'Log in', 'login.logging_in': 'Logging in...',
        'login.success': 'Login successful!', 'login.error': 'Login failed',
        'credit.balance': 'Current Balance', 'credit.diner': 'Diner', 'credit.vs': 'Variable symbol',
        'credit.current_orders': 'Current Orders', 'credit.history': 'History & Payments',
        'meals.lunch': 'Lunch', 'meals.order': 'Order', 'meals.cancel': 'Cancel', 'meals.ordered_badge': 'Ordered',
        'meals.deadline_prefix': 'by', 'meals.no_meals': 'No meals on this day',
        'meals.ordered_toast': 'ordered', 'meals.cancelled_toast': 'cancelled',
        'meals.cannot_edit': 'This meal cannot be modified', 'meals.unknown': 'Unknown meal',
        'orders.loading': 'Loading current orders\u2026', 'orders.empty': 'No orders yet',
        'history.loading': 'Loading history\u2026', 'history.empty': 'No history yet',
        'status.ordered': 'Ordered', 'status.eaten': 'Eaten', 'status.cancelled': 'Cancelled',
        'burza.empty': 'Exchange is currently empty.', 'burza.available': 'available',
        'burza.order': 'Order from exchange', 'burza.desc': 'Meal available from exchange',
        'burza.ordered_toast': 'ordered from exchange', 'burza.order_error': 'Error ordering from exchange',
        'user_default': 'iCanteen User', 'not_specified': 'Not specified',
        'session_expired': 'Session expired. Please log in again.',
        'meals_load_error': 'Failed to load meals', 'comm_error': 'Communication error',
        'notif.none': 'No new notifications', 'loading': 'Loading...',
    },
    uk: {
        'nav.jidelnicek': '\u041c\u0435\u043d\u044e', 'nav.burza': '\u041e\u0431\u043c\u0456\u043d', 'nav.credit': '\u0420\u0430\u0445\u0443\u043d\u043e\u043a', 'nav.settings': '\u041d\u0430\u043b\u0430\u0448\u0442\u0443\u0432\u0430\u043d\u043d\u044f',
        'page.menu': '\u041c\u0435\u043d\u044e', 'page.orders': '\u0417\u0430\u043c\u043e\u0432\u043b\u0435\u043d\u043d\u044f', 'page.burza': '\u041e\u0431\u043c\u0456\u043d', 'page.konto': '\u041c\u0456\u0439 \u0420\u0430\u0445\u0443\u043d\u043e\u043a', 'page.settings': '\u041d\u0430\u043b\u0430\u0448\u0442\u0443\u0432\u0430\u043d\u043d\u044f',
        'settings.appearance': '\u0412\u0438\u0433\u043b\u044f\u0434 \u0456 \u043c\u043e\u0432\u0430', 'settings.accent': '\u041a\u043e\u043b\u0456\u0440 \u0442\u0435\u043c\u0438', 'settings.dark_mode': '\u0421\u0432\u0456\u0442\u043b\u0438\u0439 \u0440\u0435\u0436\u0438\u043c',
        'settings.language': '\u041c\u043e\u0432\u0430', 'settings_saved': '\u041d\u0430\u043b\u0430\u0448\u0442\u0443\u0432\u0430\u043d\u043d\u044f \u0437\u0431\u0435\u0440\u0435\u0436\u0435\u043d\u043e',
        'settings.profile': '\u041f\u0440\u043e\u0444\u0456\u043b\u044c', 'settings.name': "\u0406\u043c'\u044f", 'settings.class': '\u041a\u043b\u0430\u0441',
        'settings.email': '\u0415\u043b. \u043f\u043e\u0448\u0442\u0430', 'settings.category': '\u041a\u0430\u0442\u0435\u0433\u043e\u0440\u0456\u044f',
        'login.subtitle': '\u0428\u043a\u0456\u043b\u044c\u043d\u0430 \u0457\u0434\u0430\u043b\u044c\u043d\u044f', 'login.username': "\u0406\u043c'\u044f \u043a\u043e\u0440\u0438\u0441\u0442\u0443\u0432\u0430\u0447\u0430", 'login.password': '\u041f\u0430\u0440\u043e\u043b\u044c',
        'login.server': 'URL \u0441\u0435\u0440\u0432\u0435\u0440\u0430 \u0457\u0434\u0430\u043b\u044c\u043d\u0456', 'login.login': '\u0423\u0432\u0456\u0439\u0442\u0438', 'login.logging_in': '\u0412\u0445\u0456\u0434...',
        'login.success': '\u0412\u0445\u0456\u0434 \u0443\u0441\u043f\u0456\u0448\u043d\u0438\u0439!', 'login.error': '\u041f\u043e\u043c\u0438\u043b\u043a\u0430 \u0432\u0445\u043e\u0434\u0443',
        'credit.balance': '\u041f\u043e\u0442\u043e\u0447\u043d\u0438\u0439 \u0431\u0430\u043b\u0430\u043d\u0441', 'credit.diner': '\u041a\u043e\u0440\u0438\u0441\u0442\u0443\u0432\u0430\u0447', 'credit.vs': '\u0412\u0430\u0440\u0456\u0430\u0442\u0438\u0432\u043d\u0438\u0439 \u0441\u0438\u043c\u0432\u043e\u043b',
        'credit.current_orders': '\u041f\u043e\u0442\u043e\u0447\u043d\u0456 \u0437\u0430\u043c\u043e\u0432\u043b\u0435\u043d\u043d\u044f', 'credit.history': '\u0406\u0441\u0442\u043e\u0440\u0456\u044f \u0442\u0430 \u041f\u043b\u0430\u0442\u0435\u0436\u0456',
        'meals.lunch': '\u041e\u0431\u0456\u0434', 'meals.order': '\u0417\u0430\u043c\u043e\u0432\u0438\u0442\u0438', 'meals.cancel': '\u0421\u043a\u0430\u0441\u0443\u0432\u0430\u0442\u0438', 'meals.ordered_badge': '\u0417\u0430\u043c\u043e\u0432\u043b\u0435\u043d\u043e',
        'meals.deadline_prefix': '\u0434\u043e', 'meals.no_meals': '\u0423 \u0446\u0435\u0439 \u0434\u0435\u043d\u044c \u043d\u0435 \u0433\u043e\u0442\u0443\u044e\u0442\u044c',
        'meals.ordered_toast': '\u0437\u0430\u043c\u043e\u0432\u043b\u0435\u043d\u043e', 'meals.cancelled_toast': '\u0441\u043a\u0430\u0441\u043e\u0432\u0430\u043d\u043e',
        'meals.cannot_edit': '\u0426\u044e \u0441\u0442\u0440\u0430\u0432\u0443 \u043d\u0435 \u043c\u043e\u0436\u043d\u0430 \u0437\u043c\u0456\u043d\u0438\u0442\u0438', 'meals.unknown': '\u041d\u0435\u0432\u0456\u0434\u043e\u043c\u0430 \u0441\u0442\u0440\u0430\u0432\u0430',
        'orders.loading': '\u0417\u0430\u0432\u0430\u043d\u0442\u0430\u0436\u0435\u043d\u043d\u044f \u0437\u0430\u043c\u043e\u0432\u043b\u0435\u043d\u044c\u2026', 'orders.empty': '\u0429\u0435 \u043d\u0435\u043c\u0430\u0454 \u0437\u0430\u043c\u043e\u0432\u043b\u0435\u043d\u044c',
        'history.loading': '\u0417\u0430\u0432\u0430\u043d\u0442\u0430\u0436\u0435\u043d\u043d\u044f \u0456\u0441\u0442\u043e\u0440\u0456\u0457\u2026', 'history.empty': '\u0429\u0435 \u043d\u0435\u043c\u0430\u0454 \u0456\u0441\u0442\u043e\u0440\u0456\u0457',
        'status.ordered': '\u0417\u0430\u043c\u043e\u0432\u043b\u0435\u043d\u043e', 'status.eaten': '\u0421\u043f\u043e\u0436\u0438\u0442\u043e', 'status.cancelled': '\u0421\u043a\u0430\u0441\u043e\u0432\u0430\u043d\u043e',
        'burza.empty': '\u041e\u0431\u043c\u0456\u043d \u043d\u0430\u0440\u0430\u0437\u0456 \u043f\u043e\u0440\u043e\u0436\u043d\u0456\u0439.', 'burza.available': '\u0434\u043e\u0441\u0442\u0443\u043f\u043d\u043e',
        'burza.order': '\u0417\u0430\u043c\u043e\u0432\u0438\u0442\u0438 \u0437 \u043e\u0431\u043c\u0456\u043d\u0443', 'burza.desc': '\u0421\u0442\u0440\u0430\u0432\u0430 \u0434\u043e\u0441\u0442\u0443\u043f\u043d\u0430 \u0437 \u043e\u0431\u043c\u0456\u043d\u0443',
        'burza.ordered_toast': '\u0437\u0430\u043c\u043e\u0432\u043b\u0435\u043d\u043e \u0437 \u043e\u0431\u043c\u0456\u043d\u0443', 'burza.order_error': '\u041f\u043e\u043c\u0438\u043b\u043a\u0430 \u0437\u0430\u043c\u043e\u0432\u043b\u0435\u043d\u043d\u044f \u0437 \u043e\u0431\u043c\u0456\u043d\u0443',
        'user_default': '\u041a\u043e\u0440\u0438\u0441\u0442\u0443\u0432\u0430\u0447 iCanteen', 'not_specified': '\u041d\u0435 \u0432\u043a\u0430\u0437\u0430\u043d\u043e',
        'session_expired': '\u0421\u0435\u0441\u0456\u044f \u0437\u0430\u043a\u0456\u043d\u0447\u0438\u043b\u0430\u0441\u044f. \u0411\u0443\u0434\u044c \u043b\u0430\u0441\u043a\u0430, \u0443\u0432\u0456\u0439\u0434\u0456\u0442\u044c \u0437\u043d\u043e\u0432\u0443.',
        'meals_load_error': '\u041d\u0435 \u0432\u0434\u0430\u043b\u043e\u0441\u044f \u0437\u0430\u0432\u0430\u043d\u0442\u0430\u0436\u0438\u0442\u0438 \u0441\u0442\u0440\u0430\u0432\u0438', 'comm_error': "\u041f\u043e\u043c\u0438\u043b\u043a\u0430 \u0437\u0432'\u044f\u0437\u043a\u0443",
        'notif.none': '\u041d\u0435\u043c\u0430\u0454 \u043d\u043e\u0432\u0438\u0445 \u0441\u043f\u043e\u0432\u0456\u0449\u0435\u043d\u044c', 'loading': '\u0417\u0430\u0432\u0430\u043d\u0442\u0430\u0436\u0435\u043d\u043d\u044f...',
    }
};

function setLanguage(lang) {
    localStorage.setItem('icanteen_lang', lang);
    const dict = translations[lang] || translations['cs'];

    // Update data-i18n elements
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        if (dict[key]) el.textContent = dict[key];
    });

    // Update data-i18n-placeholder elements
    document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
        const key = el.getAttribute('data-i18n-placeholder');
        if (dict[key]) el.placeholder = dict[key];
    });

    // Bottom nav
    const navMap = { jidelnicek: 'nav.jidelnicek', burza: 'nav.burza', konto: 'nav.credit', nastaveni: 'nav.settings' };
    for (const [page, key] of Object.entries(navMap)) {
        const el = document.querySelector(`.bottom-nav-item[data-page="${page}"] span:last-child`);
        if (el && dict[key]) el.textContent = dict[key];
    }

    // Re-render dynamic content
    updateDate();
    renderWeekDays();
    renderMeals();
    renderOrders();

    // Update current page title
    const activeNav = document.querySelector('.nav-item.active');
    if (activeNav) navigateToPage(activeNav.dataset.page);
}

function t(key, fallback = '') {
    const lang = localStorage.getItem('icanteen_lang') || 'cs';
    return (translations[lang] && translations[lang][key]) ? translations[lang][key] : fallback;
}

// ============================================================
// TOAST
// ============================================================
let toastTimeout = null;
let toastAnimTimeout = null;

function showToast(message, icon = 'check_circle') {
    const toast = $('#toast');
    const msg = $('#toast-message');
    const ic = toast.querySelector('.toast-icon');

    msg.textContent = message;
    ic.textContent = icon;

    // Clear any outgoing animations immediately to prevent glitches
    if (toastTimeout) clearTimeout(toastTimeout);
    if (toastAnimTimeout) clearTimeout(toastAnimTimeout);

    toast.classList.remove('fade-out');
    toast.style.display = 'flex'; // Force display before animating

    // Small delay to allow display:flex to apply before transition
    setTimeout(() => {
        toast.classList.add('show');
    }, 10);

    toastTimeout = setTimeout(() => {
        toast.classList.add('fade-out');
        toast.classList.remove('show');

        toastAnimTimeout = setTimeout(() => {
            toast.classList.remove('fade-out');
            toast.style.display = 'none'; // Completely hide from view
        }, 400); // 400ms CSS transition duration
    }, 3000);
}

// ---- Notification Button ----
document.addEventListener('DOMContentLoaded', () => {
    const notifBtn = $('#notification-btn');
    if (notifBtn) {
        notifBtn.addEventListener('click', () => {
            const dot = notifBtn.querySelector('.notification-dot');
            if (dot) dot.style.display = 'none';
            showToast(t('notif.none', '\u017d\u00e1dn\u00e9 nov\u00e9 upozorn\u011bn\u00ed'), 'notifications');
        });
    }
});

// ============================================================
// BOOTSTRAP APP
// ============================================================
document.addEventListener('DOMContentLoaded', () => {
    // 1. Initialize all UI and Event Listeners
    initLogin();
    initNavigation();
    initBottomNav();
    initSidebar();
    initWeekNav();
    initKonto();
    initBurza();
    initSettings();

    // 2. Check if already logged in
    const savedServer = localStorage.getItem('icanteen_server');
    const savedToken = localStorage.getItem('icanteen_pass');

    if (savedServer && savedToken) {
        APP.serverUrl = savedServer;

        // Skip login screen
        const loginScreen = document.getElementById('login-screen');
        const appScreen = document.getElementById('app-screen');

        if (loginScreen && appScreen) {
            loginScreen.classList.remove('active');
            appScreen.classList.add('active');
        }

        // Fetch User profile and Meals
        fetchUserSettings();
        fetchRealMeals();
    } else {
        // Show login screen
        const loginScreen = document.getElementById('login-screen');
        if (loginScreen) {
            loginScreen.classList.add('active');
        }
    }
});
