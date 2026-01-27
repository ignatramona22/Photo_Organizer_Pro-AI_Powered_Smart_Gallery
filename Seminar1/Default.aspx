<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Photo Organizer Pro - Bine ai venit!</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Inter', sans-serif;
            overflow-x: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        /* Animated Gradient Background */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 200%;
            height: 200%;
            background: 
                radial-gradient(circle at 20% 50%, rgba(99, 102, 241, 0.4) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(236, 72, 153, 0.4) 0%, transparent 50%),
                radial-gradient(circle at 40% 20%, rgba(139, 92, 246, 0.4) 0%, transparent 50%);
            animation: gradientMove 20s ease infinite;
            z-index: 0;
        }

        @keyframes gradientMove {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            50% { transform: translate(-50px, -50px) rotate(180deg); }
        }

        /* Floating Elements Background */
        .floating-elements {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: 1;
            pointer-events: none;
        }

        .floating-icon {
            position: absolute;
            font-size: 3rem;
            opacity: 0.1;
            animation: float 20s infinite ease-in-out;
        }

        .floating-icon:nth-child(1) {
            top: 10%;
            left: 10%;
            animation-delay: 0s;
            color: #ec4899;
        }

        .floating-icon:nth-child(2) {
            top: 60%;
            left: 80%;
            animation-delay: 5s;
            color: #f59e0b;
        }

        .floating-icon:nth-child(3) {
            top: 80%;
            left: 20%;
            animation-delay: 10s;
            color: #10b981;
        }

        .floating-icon:nth-child(4) {
            top: 20%;
            left: 70%;
            animation-delay: 15s;
            color: #3b82f6;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0) rotate(0deg);
            }
            50% {
                transform: translateY(-30px) rotate(180deg);
            }
        }

        /* Main Container */
        .landing-container {
            position: relative;
            z-index: 10;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            max-width: 1400px;
            padding: 2rem;
            gap: 4rem;
        }

        /* Left Content */
        .content-section {
            flex: 1;
            color: white;
            animation: slideInLeft 1s ease-out;
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
            animation: fadeIn 1.5s ease-out;
        }

        .logo {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            box-shadow: 0 20px 60px rgba(99, 102, 241, 0.4);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                box-shadow: 0 20px 60px rgba(99, 102, 241, 0.4);
            }
            50% {
                transform: scale(1.05);
                box-shadow: 0 25px 80px rgba(99, 102, 241, 0.6);
            }
        }

        .brand-name {
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, #ffffff, #e0e7ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        h1 {
            font-size: 4rem;
            font-weight: 900;
            line-height: 1.2;
            margin-bottom: 1.5rem;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }

        .highlight {
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .subtitle {
            font-size: 1.3rem;
            margin-bottom: 2rem;
            opacity: 0.95;
            line-height: 1.6;
        }

        .features-list {
            list-style: none;
            margin-bottom: 2.5rem;
        }

        .features-list li {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.75rem 0;
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .features-list i {
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fbbf24;
            font-size: 1.2rem;
        }

        .cta-button {
            display: inline-flex;
            align-items: center;
            gap: 1rem;
            padding: 1.2rem 3rem;
            background: white;
            color: #6366f1;
            text-decoration: none;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: 700;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
        }

        .cta-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s;
        }

        .cta-button:hover::before {
            left: 100%;
        }

        .cta-button:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 30px 80px rgba(99, 102, 241, 0.5);
        }

        .cta-button i {
            font-size: 1.5rem;
            transition: transform 0.3s ease;
        }

        .cta-button:hover i {
            transform: translateX(5px);
        }

        /* Right Section - Phone Mockup */
        .mockup-section {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            animation: slideInRight 1s ease-out;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .phone-mockup {
            position: relative;
            width: 350px;
            height: 700px;
            background: #1e293b;
            border-radius: 50px;
            padding: 15px;
            box-shadow: 0 40px 100px rgba(0, 0, 0, 0.5);
            animation: floatPhone 6s ease-in-out infinite;
        }

        @keyframes floatPhone {
            0%, 100% {
                transform: translateY(0) rotate(-2deg);
            }
            50% {
                transform: translateY(-20px) rotate(2deg);
            }
        }

        .phone-screen {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 40px;
            overflow: hidden;
            position: relative;
        }

        .phone-notch {
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 150px;
            height: 30px;
            background: #1e293b;
            border-radius: 0 0 20px 20px;
        }

        .screen-content {
            padding: 50px 20px 20px;
            height: 100%;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .screen-header {
            background: rgba(255, 255, 255, 0.95);
            padding: 15px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .screen-header i {
            font-size: 1.5rem;
            color: #6366f1;
        }

        .screen-header span {
            font-weight: 700;
            color: #1e293b;
        }

        .photo-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            flex: 1;
        }

        .photo-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            animation: fadeInScale 1s ease-out forwards;
            opacity: 0;
        }

        .photo-card:nth-child(1) { animation-delay: 0.2s; }
        .photo-card:nth-child(2) { animation-delay: 0.4s; }
        .photo-card:nth-child(3) { animation-delay: 0.6s; }
        .photo-card:nth-child(4) { animation-delay: 0.8s; }

        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.8);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .photo-placeholder {
            width: 100%;
            height: 120px;
            background: linear-gradient(135deg, #ec4899, #f472b6);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
        }

        .photo-card:nth-child(2) .photo-placeholder {
            background: linear-gradient(135deg, #10b981, #34d399);
        }

        .photo-card:nth-child(3) .photo-placeholder {
            background: linear-gradient(135deg, #f59e0b, #fbbf24);
        }

        .photo-card:nth-child(4) .photo-placeholder {
            background: linear-gradient(135deg, #3b82f6, #60a5fa);
        }

        /* Floating Icons Around Phone */
        .floating-app-icon {
            position: absolute;
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            animation: floatAround 4s ease-in-out infinite;
        }

        .app-icon-1 {
            top: 50px;
            left: -80px;
            background: linear-gradient(135deg, #ec4899, #f472b6);
            animation-delay: 0s;
        }

        .app-icon-2 {
            top: 200px;
            right: -80px;
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            animation-delay: 1s;
        }

        .app-icon-3 {
            bottom: 150px;
            left: -80px;
            background: linear-gradient(135deg, #a855f7, #c084fc);
            animation-delay: 2s;
        }

        @keyframes floatAround {
            0%, 100% {
                transform: translateY(0) rotate(0deg);
            }
            50% {
                transform: translateY(-15px) rotate(5deg);
            }
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .landing-container {
                flex-direction: column;
                text-align: center;
            }

            h1 {
                font-size: 3rem;
            }

            .phone-mockup {
                width: 300px;
                height: 600px;
            }

            .floating-app-icon {
                display: none;
            }
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 2.5rem;
            }

            .subtitle {
                font-size: 1.1rem;
            }

            .features-list {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="floating-elements">
        <i class="fas fa-camera floating-icon"></i>
        <i class="fas fa-image floating-icon"></i>
        <i class="fas fa-heart floating-icon"></i>
        <i class="fas fa-star floating-icon"></i>
    </div>

    <div class="landing-container">
        <!-- Left Content -->
        <div class="content-section">
            <div class="logo-section">
                <div class="logo">
                    <i class="fas fa-camera-retro"></i>
                </div>
                <div class="brand-name">Photo Organizer Pro</div>
            </div>

            <h1>
                Organizează-ți<br/>
                amintirile <span class="highlight">inteligent</span>
            </h1>

            <p class="subtitle">
                Platforma perfectă pentru a-ți gestiona fotografiile cu ajutorul inteligenței artificiale. 
                Caută, editează și organizează mii de poze într-un singur loc.
            </p>

            <ul class="features-list">
                <li>
                    <i class="fas fa-check-circle"></i>
                    <span>Căutare inteligentă prin similaritate</span>
                </li>
                <li>
                    <i class="fas fa-check-circle"></i>
                    <span>Detectare automată cu AI a conținutului</span>
                </li>
                <li>
                    <i class="fas fa-check-circle"></i>
                    <span>Organizare în albume personalizate</span>
                </li>
                <li>
                    <i class="fas fa-check-circle"></i>
                    <span>Editare și prelucrare rapidă</span>
                </li>
            </ul>

            <a href="imagini.aspx" class="cta-button">
                <span>Începe Acum</span>
                <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <!-- Right Mockup -->
        <div class="mockup-section">
            <div class="phone-mockup">
                <div class="phone-screen">
                    <div class="phone-notch"></div>
                    <div class="screen-content">
                        <div class="screen-header">
                            <i class="fas fa-images"></i>
                            <span>Galerie</span>
                        </div>
                        <div class="photo-grid">
                            <div class="photo-card">
                                <div class="photo-placeholder">📷</div>
                            </div>
                            <div class="photo-card">
                                <div class="photo-placeholder">🌄</div>
                            </div>
                            <div class="photo-card">
                                <div class="photo-placeholder">🎨</div>
                            </div>
                            <div class="photo-card">
                                <div class="photo-placeholder">✨</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Floating Icons -->
            <div class="floating-app-icon app-icon-1">
                <i class="fas fa-heart"></i>
            </div>
            <div class="floating-app-icon app-icon-2">
                <i class="fas fa-star"></i>
            </div>
            <div class="floating-app-icon app-icon-3">
                <i class="fas fa-magic"></i>
            </div>
        </div>
    </div>
</body>
</html>