<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Générateur - SYSTEM BREACH</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background-color: #050505;
            color: #00ff41;
            font-family: 'Courier New', Courier, monospace;
            overflow: hidden;
            height: 100vh;
            width: 100vw;
        }
        #setup-overlay {
            position: fixed;
            inset: 0;
            background: #0a0a0a;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10000;
            padding: 20px;
        }
        .setup-box {
            background: #141414;
            border: 1px solid #00ff41;
            padding: 30px;
            border-radius: 6px;
            text-align: center;
            max-width: 480px;
            width: 100%;
            box-shadow: 0 0 25px rgba(0, 255, 65, 0.15);
        }
        .setup-box h2 { margin-bottom: 12px; font-size: 20px; letter-spacing: 1px; }
        .setup-box p { color: #aaa; font-size: 13px; margin-bottom: 20px; line-height: 1.5; }
        .btn {
            display: block;
            width: 100%;
            padding: 13px;
            margin-bottom: 12px;
            font-family: 'Courier New', Courier, monospace;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            border-radius: 4px;
            text-transform: uppercase;
            transition: 0.2s;
        }
        .btn-test {
            background: transparent;
            color: #00ff41;
            border: 1px solid #00ff41;
        }
        .btn-test:hover { background: rgba(0, 255, 65, 0.15); }
        .file-label {
            display: block;
            background: #1f1f1f;
            color: #fff;
            border: 1px dashed #666;
            padding: 15px;
            margin-bottom: 12px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 13px;
        }
        .file-label:hover { border-color: #00ff41; }
        input[type="file"] { display: none; }
        .btn-download {
            background: #00ff41;
            color: #050505;
            border: none;
            opacity: 0.4;
            pointer-events: none;
        }
        .btn-download.ready {
            opacity: 1;
            pointer-events: auto;
        }
        .btn-download.ready:hover { background: #00cc33; }
        #status-msg { font-size: 12px; color: #00ff41; margin-bottom: 15px; min-height: 16px; }

        /* Styles du Terminal et de la Vidéo (pour l'aperçu) */
        #terminal {
            display: none;
            padding: 25px;
            font-size: 16px;
            line-height: 1.5;
            height: 100%;
            width: 100%;
            overflow-y: auto;
            text-shadow: 0 0 5px #00ff41;
        }
        .cursor {
            display: inline-block;
            width: 10px;
            height: 18px;
            background-color: #00ff41;
            animation: blink 0.8s infinite;
            vertical-align: middle;
        }
        @keyframes blink { 0%, 49% { opacity: 1; } 50%, 100% { opacity: 0; } }
        .alert { color: #ff003c; text-shadow: 0 0 8px #ff003c; font-weight: bold; }
        #preview-screen {
            display: none;
            position: fixed;
            inset: 0;
            background: #000;
            z-index: 9999;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }
    </style>
</head>
<body>

    <div id="setup-overlay">
        <div class="setup-box">
            <h2>[ GÉNÉRATEUR DE SITE ]</h2>
            <p>1. Testez l'animation dès maintenant.<br>2. Quand votre vidéo est prête, importez-la pour télécharger votre site final prêt à l'emploi.</p>
            
            <button class="btn btn-test" id="test-btn">▶ Tester le rendu (sans vidéo)</button>
            
            <hr style="border: 0; border-top: 1px solid #333; margin: 20px 0;">

            <label class="file-label" for="video-input">
                📁 Sélectionner votre vidéo (.mp4)
            </label>
            <input type="file" id="video-input" accept="video/mp4,video/webm">
            <div id="status-msg">Aucune vidéo sélectionnée</div>

            <button class="btn btn-download" id="download-btn">⬇ Télécharger le site final (.html)</button>
        </div>
    </div>

    <div id="terminal">
        <div id="output"></div><span class="cursor"></span>
    </div>

    <div id="preview-screen">
        <h1 style="color: #00ff41; font-size: 28px; margin-bottom: 15px;">[ VOTRE VIDÉO S'AFFICHERA ICI EN PLEIN ÉCRAN ]</h1>
        <p style="color: #888; margin-bottom: 25px;">(Fin de la séquence de piratage)</p>
        <button class="btn btn-test" style="width: auto; padding: 10px 25px;" onclick="location.reload()">Retour au menu</button>
    </div>

    <script>
        const videoInput = document.getElementById('video-input');
        const statusMsg = document.getElementById('status-msg');
        const downloadBtn = document.getElementById('download-btn');
        const testBtn = document.getElementById('test-btn');
        const setupOverlay = document.getElementById('setup-overlay');
        const terminal = document.getElementById('terminal');
        const output = document.getElementById('output');
        const previewScreen = document.getElementById('preview-screen');

        let videoDataUrl = "";

        // 1. Chargement et encodage de la vidéo choisie
        videoInput.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (!file) return;

            statusMsg.textContent = "Encodage de la vidéo en cours... Patientez.";
            downloadBtn.classList.remove('ready');

            const reader = new FileReader();
            reader.onload = function(event) {
                videoDataUrl = event.target.result;
                statusMsg.textContent = "✔ Vidéo prête : " + file.name;
                downloadBtn.classList.add('ready');
            };
            reader.readAsDataURL(file);
        });

        // 2. Génération et téléchargement du fichier HTML autonome
        downloadBtn.addEventListener('click', () => {
            if (!videoDataUrl) return;

            const finalHtml = `<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SYSTEM BREACH</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #050505; color: #00ff41; font-family: 'Courier New', monospace; overflow: hidden; height: 100vh; width: 100vw; }
        #start-overlay { position: fixed; inset: 0; background: #050505; display: flex; justify-content: center; align-items: center; z-index: 10000; }
        #start-btn { border: 2px solid #00ff41; padding: 15px 30px; font-size: 20px; color: #00ff41; background: transparent; font-family: inherit; text-transform: uppercase; letter-spacing: 3px; cursor: pointer; box-shadow: 0 0 15px rgba(0,255,65,0.3); }
        #start-btn:hover { background: #00ff41; color: #050505; }
        #terminal { padding: 25px; font-size: 16px; line-height: 1.5; height: 100%; width: 100%; overflow-y: auto; text-shadow: 0 0 5px #00ff41; }
        .cursor { display: inline-block; width: 10px; height: 18px; background: #00ff41; animation: blink 0.8s infinite; vertical-align: middle; }
        @keyframes blink { 0%, 49% { opacity: 1; } 50%, 100% { opacity: 0; } }
        .alert { color: #ff003c; text-shadow: 0 0 8px #ff003c; font-weight: bold; }
        #video-container { display: none; position: fixed; inset: 0; background: #000; z-index: 9999; }
        video { width: 100%; height: 100%; object-fit: cover; }
    </style>
</head>
<body>
    <div id="start-overlay"><button id="start-btn">[ INITIALISER LA CONNEXION ]</button></div>
    <div id="terminal"><div id="output"></div><span class="cursor"></span></div>
    <div id="video-container"><video id="hack-video" playsinline src="${videoDataUrl}"></video></div>
    <script>
        const lines = [
            "root@kali:~# ./exploit_kernel.sh --target=192.168.1.104",
            "[*] Initializing payload injection...",
            "[*] Bypassing firewall rules [OK]",
            "[*] Scanning open ports: 22, 80, 443, 8080...",
            "[+] Vulnerability found: CVE-2026-8841 (Buffer Overflow)",
            "[*] Escalating privileges to ROOT...",
            "[+] Access granted: UID=0 (root)",
            "[*] Extracting encrypted credentials from /etc/shadow...",
            "    -> hash_01: $6$rounds=656000$8f9a2b1c$...",
            "    -> hash_02: $6$rounds=656000$3e7d9a0f$...",
            "[*] Disabling system logs & intrusion detection...",
            "[!] WARNING: SYSTEM COMPROMISED",
            "[*] Uploading remote execution payload (payload.bin)...",
            "[========================================] 100%",
            "[*] Taking full control of display interface...",
            "[!] EXECUTING OVERRIDE..."
        ];
        const output = document.getElementById('output');
        const terminal = document.getElementById('terminal');
        const videoContainer = document.getElementById('video-container');
        const video = document.getElementById('hack-video');
        let i = 0;
        function nextLine() {
            if (i < lines.length) {
                const p = document.createElement('div');
                if (lines[i].includes("[!]")) p.classList.add("alert");
                p.textContent = lines[i++];
                output.appendChild(p);
                terminal.scrollTop = terminal.scrollHeight;
                setTimeout(nextLine, Math.floor(Math.random() * 200) + 80);
            } else {
                setTimeout(() => {
                    terminal.style.display = 'none';
                    videoContainer.style.display = 'block';
                    if (document.documentElement.requestFullscreen) document.documentElement.requestFullscreen().catch(()=>{});
                    video.play().catch(()=>{});
                }, 500);
            }
        }
        document.getElementById('start-btn').addEventListener('click', () => {
            document.getElementById('start-overlay').style.display = 'none';
            nextLine();
        });
    <\/script>
</body>
</html>`;

            const blob = new Blob([finalHtml], { type: 'text/html' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'index.html';
            a.click();
            URL.revokeObjectURL(url);
        });

        // 3. Mode Test (sans vidéo)
        const testLines = [
            "root@kali:~# ./exploit_kernel.sh --target=192.168.1.104",
            "[*] Initializing payload injection...",
            "[*] Bypassing firewall rules [OK]",
            "[*] Scanning open ports: 22, 80, 443, 8080...",
            "[+] Vulnerability found: CVE-2026-8841 (Buffer Overflow)",
            "[*] Escalating privileges to ROOT...",
            "[+] Access granted: UID=0 (root)",
            "[*] Extracting encrypted credentials from /etc/shadow...",
            "[!] WARNING: SYSTEM COMPROMISED",
            "[========================================] 100%",
            "[!] EXECUTING OVERRIDE..."
        ];

        testBtn.addEventListener('click', () => {
            setupOverlay.style.display = 'none';
            terminal.style.display = 'block';
            output.innerHTML = '';
            let idx = 0;

            function runTest() {
                if (idx < testLines.length) {
                    const p = document.createElement('div');
                    if (testLines[idx].includes("[!]")) p.classList.add("alert");
                    p.textContent = testLines[idx++];
                    output.appendChild(p);
                    setTimeout(runTest, 180);
                } else {
                    setTimeout(() => {
                        terminal.style.display = 'none';
                        previewScreen.style.display = 'flex';
                    }, 500);
                }
            }
            runTest();
        });
    </script>
</body>
</html>
