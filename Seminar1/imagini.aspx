<%@ Page Language="C#" Async="true" AutoEventWireup="true" CodeBehind="imagini.aspx.cs" Inherits="Seminar1.imagini" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Photo Organizer Pro - Smart Gallery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary: #6366f1;
            --secondary: #8b5cf6;
            --accent: #ec4899;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --dark: #1e293b;
            --light: #f8fafc;
            --sidebar-width: 280px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* Animated background - matching Default.aspx */
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
            pointer-events: none;
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
            opacity: 0.08;
            animation: float 25s infinite ease-in-out;
        }

        .floating-icon:nth-child(1) {
            top: 15%;
            left: 10%;
            animation-delay: 0s;
            color: #ec4899;
        }

        .floating-icon:nth-child(2) {
            top: 65%;
            left: 85%;
            animation-delay: 7s;
            color: #f59e0b;
        }

        .floating-icon:nth-child(3) {
            top: 75%;
            left: 15%;
            animation-delay: 14s;
            color: #10b981;
        }

        .floating-icon:nth-child(4) {
            top: 25%;
            left: 75%;
            animation-delay: 21s;
            color: #3b82f6;
        }

        .floating-icon:nth-child(5) {
            top: 50%;
            left: 50%;
            animation-delay: 10s;
            color: #8b5cf6;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0) rotate(0deg);
            }
            50% {
                transform: translateY(-40px) rotate(180deg);
            }
        }

        /* Enhanced Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.15);
            padding: 1.2rem 2.5rem;
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
        }

        .navbar-brand {
            font-size: 1.6rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
        }

        .navbar-brand i {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            animation: pulse 2s ease-in-out infinite;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.3);
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.08); }
        }

        /* Main Container */
        .main-container {
            display: flex;
            min-height: calc(100vh - 90px);
            position: relative;
            z-index: 2;
        }

        /* Enhanced Sidebar */
        .sidebar {
            width: var(--sidebar-width);
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            padding: 2rem 1.5rem;
            box-shadow: 4px 0 30px rgba(0, 0, 0, 0.15);
            position: sticky;
            top: 90px;
            height: calc(100vh - 90px);
            overflow-y: auto;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
        }

        .sidebar-menu li {
            margin-bottom: 0.5rem;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 1.2rem;
            color: var(--dark);
            text-decoration: none;
            border-radius: 15px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 600;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .sidebar-menu a::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 0;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 15px;
            z-index: -1;
        }

        .sidebar-menu a:hover::before,
        .sidebar-menu a.active::before {
            width: 100%;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            color: white;
            transform: translateX(8px);
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
        }

        .sidebar-menu i {
            font-size: 1.3rem;
            width: 28px;
            text-align: center;
        }

        /* Content Area */
        .content-area {
            flex: 1;
            padding: 2.5rem;
            overflow-y: auto;
        }

        .section {
            display: none;
            animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .section.active {
            display: block;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Enhanced Cards */
        .card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.4);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            padding: 2.5rem;
            margin-bottom: 2rem;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.2);
        }

        .card-title {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--dark);
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .card-title i {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        /* Form Controls */
        .form-label {
            color: var(--dark);
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 0.6rem;
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control, .form-select {
            border: 2px solid #e2e8f0;
            border-radius: 14px;
            padding: 1rem 1.4rem;
            font-size: 1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: white;
            width: 100%;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
            outline: none;
            transform: translateY(-2px);
        }

        .form-group {
            margin-bottom: 1.8rem;
        }

        /* Enhanced Buttons */
        .btn {
            padding: 1rem 2rem;
            border-radius: 14px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            position: relative;
            overflow: hidden;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn:hover::before {
            width: 400px;
            height: 400px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
        }

        .btn-warning {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            box-shadow: 0 8px 20px rgba(245, 158, 11, 0.4);
        }

        .btn-info {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 8px 20px rgba(239, 68, 68, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #64748b, #475569);
            color: white;
            box-shadow: 0 8px 20px rgba(100, 116, 139, 0.4);
        }

        .btn:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.3);
        }

        .w-100 { width: 100%; }

        /* Alert Styles */
        .alert {
            border-radius: 18px;
            padding: 1.4rem 2rem;
            margin-bottom: 1.5rem;
            border: none;
            font-weight: 600;
            animation: slideDown 0.5s ease;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert i {
            font-size: 1.5rem;
        }

        .alert-info {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1e40af;
            border-left: 5px solid #3b82f6;
        }

        .alert-warning {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            color: #92400e;
            border-left: 5px solid #f59e0b;
        }

        .alert-success {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border-left: 5px solid #10b981;
        }

        .alert-danger {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
            border-left: 5px solid #ef4444;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Stats Cards - Dashboard */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 2rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 2.5rem;
            border-radius: 24px;
            box-shadow: 0 20px 50px rgba(99, 102, 241, 0.4);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
            animation: rotate 25s linear infinite;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .stat-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 30px 70px rgba(99, 102, 241, 0.5);
        }

        .stat-card i {
            font-size: 3.5rem;
            opacity: 0.9;
            margin-bottom: 1.2rem;
        }

        .stat-card h3 {
            font-size: 3rem;
            font-weight: 900;
            margin: 0.5rem 0;
        }

        .stat-card p {
            opacity: 0.95;
            margin: 0;
            font-size: 1rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Gallery Grid */
        .gallery-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2.5rem;
            gap: 1.5rem;
            flex-wrap: wrap;
            padding: 1.5rem;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
        }

        .gallery-search-container {
            flex: 1;
            min-width: 280px;
            position: relative;
        }

        .gallery-search-container i {
            position: absolute;
            left: 1.2rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 1.2rem;
        }

        .gallery-search-container input {
            padding-left: 3.5rem;
        }

        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            padding: 0.5rem;
        }

        /* Enhanced Gallery Items */
        .gallery-item {
            background: white;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            position: relative;
        }

        .gallery-item::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.08), rgba(139, 92, 246, 0.08));
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }

        .gallery-item:hover::after {
            opacity: 1;
        }

        .gallery-item:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 25px 60px rgba(99, 102, 241, 0.3);
        }

        .gallery-item-image-container {
            position: relative;
            width: 100%;
            padding-top: 75%;
            overflow: hidden;
            background: linear-gradient(135deg, #f8fafc, #e2e8f0);
        }

        .gallery-item img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .gallery-item:hover img {
            transform: scale(1.15);
        }

        .gallery-item-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(to bottom, 
                rgba(0, 0, 0, 0) 0%, 
                rgba(0, 0, 0, 0.4) 50%,
                rgba(0, 0, 0, 0.9) 100%);
            opacity: 0;
            transition: opacity 0.4s ease;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 2rem;
        }

        .gallery-item:hover .gallery-item-overlay {
            opacity: 1;
        }

        .quick-actions {
            display: flex;
            gap: 0.75rem;
            margin-top: 1rem;
        }

        .quick-action-btn {
            flex: 1;
            padding: 0.75rem;
            background: rgba(255, 255, 255, 0.98);
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 700;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .quick-action-btn:hover {
            background: white;
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
        }

        .gallery-item-info {
            padding: 1.5rem;
        }

        .gallery-item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .gallery-item-id {
            font-weight: 900;
            font-size: 1.2rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .gallery-item-date {
            font-size: 0.75rem;
            color: #94a3b8;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .gallery-item-desc {
            color: #475569;
            font-size: 0.95rem;
            line-height: 1.7;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            margin-bottom: 1.2rem;
            min-height: 3.4em;
        }

        .gallery-item-meta {
            display: flex;
            gap: 0.6rem;
            flex-wrap: wrap;
        }

        .meta-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.5rem 0.9rem;
            background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
            border-radius: 20px;
            font-size: 0.75rem;
            color: #475569;
            font-weight: 700;
            transition: all 0.3s ease;
        }

        .meta-badge:hover {
            background: linear-gradient(135deg, #e2e8f0, #cbd5e0);
            transform: scale(1.08);
        }

        .meta-badge i {
            color: var(--primary);
            font-size: 0.9rem;
        }

        /* Single Image Display */
        .image-display {
            background: rgba(30, 41, 59, 0.05);
            border-radius: 24px;
            padding: 4rem;
            text-align: center;
            min-height: 650px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            border: 3px dashed #cbd5e0;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }

        .image-display::before {
            content: '📸';
            position: absolute;
            font-size: 12rem;
            opacity: 0.04;
            z-index: 0;
            animation: float 4s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-25px); }
        }

        .image-display:hover {
            border-color: var(--primary);
            background: linear-gradient(135deg, #eef2ff, #e0e7ff);
        }

        .image-display img {
            max-width: 100%;
            max-height: 750px;
            border-radius: 24px;
            box-shadow: 0 40px 100px rgba(0, 0, 0, 0.35);
            transition: transform 0.5s ease;
            position: relative;
            z-index: 1;
        }

        .image-display img:hover {
            transform: scale(1.03);
        }

        /* Albums Section */
        .albums-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .album-card {
            background: white;
            border-radius: 24px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.12);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .album-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            transform: scaleX(0);
            transition: transform 0.4s ease;
        }

        .album-card:hover::before {
            transform: scaleX(1);
        }

        .album-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
        }

        .album-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            box-shadow: 0 10px 30px rgba(99, 102, 241, 0.3);
        }

        .album-icon i {
            font-size: 2rem;
            color: white;
        }

        .album-title {
            font-size: 1.3rem;
            font-weight: 800;
            color: var(--dark);
            margin-bottom: 0.6rem;
        }

        .album-count {
            color: #64748b;
            font-size: 0.95rem;
            font-weight: 600;
        }

        /* Metadata Grid */
        .metadata-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 5rem 2rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 7rem;
            color: #cbd5e0;
            margin-bottom: 2rem;
            animation: float 4s ease-in-out infinite;
        }

        .empty-state h3 {
            font-size: 2rem;
            color: var(--dark);
            font-weight: 800;
            margin-bottom: 1rem;
        }

        .empty-state p {
            font-size: 1.1rem;
            color: #94a3b8;
        }

        /* Responsive Design */
        @media (max-width: 968px) {
            .sidebar {
                display: none;
            }

            .content-area {
                padding: 1.5rem;
            }

            .gallery-grid {
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                gap: 1.5rem;
            }

            .gallery-header {
                flex-direction: column;
            }

            .gallery-search-container {
                width: 100%;
            }
        }

        /* Loading Animation */
        .loading-spinner {
            display: inline-block;
            width: 60px;
            height: 60px;
            border: 6px solid #f3f4f6;
            border-top: 6px solid var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="floating-elements">
        <i class="fas fa-camera floating-icon"></i>
        <i class="fas fa-image floating-icon"></i>
        <i class="fas fa-heart floating-icon"></i>
        <i class="fas fa-star floating-icon"></i>
        <i class="fas fa-magic floating-icon"></i>
    </div>

    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:HiddenField ID="hdnActiveSection" runat="server" Value="dashboard" />

        <!-- Navbar -->
        <nav class="navbar">
            <a href="Default.aspx" class="navbar-brand">
                <i class="fas fa-camera-retro"></i>
                Photo Organizer Pro
            </a>
        </nav>

        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <ul class="sidebar-menu">
                    <li><a href="#" class="menu-link active" data-section="dashboard">
                        <i class="fas fa-th-large"></i> Dashboard
                    </a></li>
                    <li><a href="#" class="menu-link" data-section="albums">
                        <i class="fas fa-folder-open"></i> Albume
                    </a></li>
                    <li><a href="#" class="menu-link" data-section="gallery">
                        <i class="fas fa-images"></i> Toate Fotografiile
                    </a></li>
                    <li><a href="#" class="menu-link" data-section="upload">
                        <i class="fas fa-cloud-upload-alt"></i> Încarcă Poze
                    </a></li>
                    <li><a href="#" class="menu-link" data-section="edit">
                        <i class="fas fa-magic"></i> Editare
                    </a></li>
                    <li><a href="#" class="menu-link" data-section="search">
                        <i class="fas fa-search"></i> Căutare Avansată
                    </a></li>
                    <li><a href="#" class="menu-link" data-section="ml">
                        <i class="fas fa-robot"></i> Detectare Automată
                    </a></li>
                    <li><a href="#" class="menu-link" data-section="settings">
                        <i class="fas fa-cog"></i> Setări
                    </a></li>
                </ul>
            </aside>

            <!-- Content Area -->
            <main class="content-area">
                <asp:Label ID="ecou" runat="server" CssClass="alert alert-info" Visible="false"></asp:Label>

                <!-- Dashboard Section -->
                <div class="section active" id="dashboard">
                    <div class="stats-grid">
                        <div class="stat-card">
                            <i class="fas fa-images"></i>
                            <h3><asp:Label ID="lbl_totalImagini" runat="server" Text="0"></asp:Label></h3>
                            <p>Total Fotografii</p>
                        </div>
                        <div class="stat-card" style="background: linear-gradient(135deg, #10b981, #059669);">
                            <i class="fas fa-tags"></i>
                            <h3><asp:Label ID="lbl_totalTaguri" runat="server" Text="0"></asp:Label></h3>
                            <p>Tag-uri Unice</p>
                        </div>
                        <div class="stat-card" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                            <i class="fas fa-map-marker-alt"></i>
                            <h3><asp:Label ID="lbl_totalLocatii" runat="server" Text="0"></asp:Label></h3>
                            <p>Locații Vizitate</p>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-clock"></i>
                            Adăugate Recent
                        </div>
                        <p style="color: #64748b; font-size: 1.05rem;">Ultimele fotografii încărcate vor apărea aici. Începe prin a încărca prima ta poză!</p>
                    </div>
                </div>

                <!-- Albums Section -->
                <div class="section" id="albums">
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-folder-open"></i>
                            Albumele Mele
                        </div>
                        
                        <div class="albums-grid">
                            <div class="album-card" onclick="filterByTag('familie')">
                                <div class="album-icon">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="album-title">Familie</div>
                                <div class="album-count">0 fotografii</div>
                            </div>

                            <div class="album-card" onclick="filterByTag('vacanta')">
                                <div class="album-icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                                    <i class="fas fa-plane"></i>
                                </div>
                                <div class="album-title">Vacanțe</div>
                                <div class="album-count">0 fotografii</div>
                            </div>

                            <div class="album-card" onclick="filterByTag('natura')">
                                <div class="album-icon" style="background: linear-gradient(135deg, #10b981, #34d399);">
                                    <i class="fas fa-leaf"></i>
                                </div>
                                <div class="album-title">Natură</div>
                                <div class="album-count">0 fotografii</div>
                            </div>

                            <div class="album-card" onclick="filterByTag('evenimente')">
                                <div class="album-icon" style="background: linear-gradient(135deg, #ec4899, #f472b6);">
                                    <i class="fas fa-birthday-cake"></i>
                                </div>
                                <div class="album-title">Evenimente</div>
                                <div class="album-count">0 fotografii</div>
                            </div>

                            <div class="album-card" onclick="filterByTag('animale')">
                                <div class="album-icon" style="background: linear-gradient(135deg, #f59e0b, #fbbf24);">
                                    <i class="fas fa-paw"></i>
                                </div>
                                <div class="album-title">Animale</div>
                                <div class="album-count">0 fotografii</div>
                            </div>

                            <div class="album-card" onclick="showAllPhotos()">
                                <div class="album-icon" style="background: linear-gradient(135deg, #64748b, #94a3b8);">
                                    <i class="fas fa-th"></i>
                                </div>
                                <div class="album-title">Toate Pozele</div>
                                <div class="album-count">Vezi toate</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Gallery Section -->
                <div class="section" id="gallery">
                    <div class="card">
                        <div class="gallery-header">
                            <div class="gallery-search-container">
                                <i class="fas fa-search"></i>
                                <asp:TextBox ID="tb_img" runat="server" CssClass="form-control" 
                                    placeholder="Caută după ID sau descriere..."></asp:TextBox>
                            </div>
                            <div style="display: flex; gap: 0.75rem;">
                                <asp:Button ID="afiseazaImagine" runat="server" Text="🔍 Caută" 
                                    CssClass="btn btn-success" OnClick="afiseazaImagine_Click" />
                                <asp:Button ID="btn_afiseaza_toate" runat="server" Text="🖼️ Toate" 
                                    CssClass="btn btn-secondary" OnClick="btn_afiseaza_toate_Click" />
                            </div>
                        </div>

                        <!-- Single Image Display -->
                        <div id="singleImageContainer" runat="server" visible="false">
                            <div class="image-display">
                                <asp:Image ID="img" runat="server" />
                            </div>
                        </div>

                        <!-- Gallery Grid -->
                        <div id="galleryContainer" runat="server" class="gallery-grid"></div>
                    </div>
                </div>

                <!-- Upload Section -->
                <div class="section" id="upload">
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-cloud-upload-alt"></i>
                            Încarcă Fotografii Noi
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-hashtag"></i> ID Imagine
                            </label>
                            <asp:TextBox ID="tb_id" runat="server" CssClass="form-control" 
                                placeholder="Ex: 101"></asp:TextBox>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-align-left"></i> Descriere
                            </label>
                            <asp:TextBox ID="tb_descriere" runat="server" CssClass="form-control" 
                                placeholder="Adaugă o descriere pentru această fotografie..." 
                                TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>

                        <div class="metadata-grid">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-calendar"></i> Data
                                </label>
                                <asp:TextBox ID="tb_metaDate" runat="server" CssClass="form-control" 
                                    TextMode="Date"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-map-marker-alt"></i> Locație
                                </label>
                                <asp:TextBox ID="tb_metaLocatie" runat="server" CssClass="form-control" 
                                    placeholder="Ex: Cluj-Napoca, România"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-tags"></i> Tag-uri (separate prin virgulă)
                            </label>
                            <asp:TextBox ID="tb_tags" runat="server" CssClass="form-control" 
                                placeholder="Ex: familie, vacanta, munte, soare"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-image"></i> Selectează Fișierul
                            </label>
                            <asp:FileUpload ID="FileUpload1" runat="server" CssClass="form-control" />
                        </div>

                        <asp:Button ID="btn_submit" runat="server" Text="📤 Încarcă Fotografia" 
                            CssClass="btn btn-primary w-100" OnClick="btn_submit_Click" />
                    </div>
                </div>

                <!-- Edit Section -->
                <div class="section" id="edit">
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-magic"></i>
                            Editare și Prelucrare
                        </div>

                        <div class="form-group">
                            <label class="form-label">ID Imagine pentru Procesare</label>
                            <asp:TextBox ID="tb_resize_id" runat="server" CssClass="form-control" 
                                placeholder="Introdu ID-ul imaginii"></asp:TextBox>
                        </div>

                        <div class="metadata-grid">
                            <div class="form-group">
                                <label class="form-label">Lățime Nouă (px)</label>
                                <asp:TextBox ID="tb_w" runat="server" CssClass="form-control" 
                                    placeholder="800"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Înălțime Nouă (px)</label>
                                <asp:TextBox ID="tb_h" runat="server" CssClass="form-control" 
                                    placeholder="600"></asp:TextBox>
                            </div>
                        </div>

                        <asp:Button ID="btn_resize" runat="server" Text="✨ Redimensionează" 
                            CssClass="btn btn-warning w-100 mb-3" OnClick="btn_resize_Click" />

<hr style="margin:2rem 0; border:none; height:2px; background:linear-gradient(90deg, transparent, #e2e8f0, transparent);" />

<h5 style="font-weight:700;color:#1e293b;margin-bottom:1rem;">🎨 Alte Opțiuni de Editare</h5>

<div class="form-group">
    <label class="form-label">Unghi de Rotire (°)</label>
    <asp:TextBox ID="tb_rotate_angle" runat="server" CssClass="form-control" placeholder="Ex: 90"></asp:TextBox>
    <asp:Button ID="btn_rotate" runat="server" Text="↻ Rotește Imaginea" CssClass="btn btn-info w-100 mt-2" OnClick="btn_rotate_Click" />
</div>

<div class="metadata-grid">
    <div class="form-group">
        <label class="form-label">Luminozitate (0.5 = mai întunecată, 1.5 = mai luminoasă)</label>
        <asp:TextBox ID="tb_brightness" runat="server" CssClass="form-control" placeholder="1.0"></asp:TextBox>
    </div>
    <div class="form-group">
        <label class="form-label">Contrast (1.0 = normal, 2.0 = mai contrastat)</label>
        <asp:TextBox ID="tb_contrast" runat="server" CssClass="form-control" placeholder="1.0"></asp:TextBox>
    </div>
</div>
<asp:Button ID="btn_adjust" runat="server" Text="🌈 Ajustează Luminozitatea/Contrastul" CssClass="btn btn-success w-100 mt-2" OnClick="btn_adjust_Click" />

<div class="form-group mt-4">
    <asp:Button ID="btn_grayscale" runat="server" Text="🖤 Transformă în Alb-Negru" CssClass="btn btn-secondary w-100 mb-2" OnClick="btn_grayscale_Click" />
    <asp:Button ID="btn_sepia" runat="server" Text="🟤 Aplică Filtru Sepia" CssClass="btn btn-warning w-100" OnClick="btn_sepia_Click" />
</div>

                        <div class="form-group">
                            <label class="form-label">Export Imagine (ID)</label>
                            <asp:TextBox ID="tb_export_id" runat="server" CssClass="form-control" 
                                placeholder="ID pentru descărcare"></asp:TextBox>
                        </div>

                        <asp:Button ID="btn_export" runat="server" Text="💾 Descarcă Imaginea" 
                            CssClass="btn btn-info w-100" OnClick="btn_export_Click" />
                    </div>
                </div>

                <!-- Search Section -->
                <div class="section" id="search">
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-brain"></i>
                            Căutare Inteligentă prin Similaritate
                        </div>

                        <p style="color: #64748b; margin-bottom: 2rem; font-size: 1.05rem; line-height: 1.7;">
                            Încarcă o imagine și sistemul va găsi automat fotografii similare din colecția ta bazate pe culoare, textură și formă.
                        </p>

                        <div class="form-group">
                            <label class="form-label">Încarcă Imagine pentru Căutare</label>
                            <asp:FileUpload ID="FileUpload2" runat="server" CssClass="form-control" />
                        </div>

                        <label class="form-label">⚙️ Setări Avansate de Similaritate</label>

                        <div class="metadata-grid">
                            <div class="form-group">
                                <label style="font-size: 0.85rem; font-weight: 600;">🎨 Culoare</label>
                                <asp:DropDownList ID="ddl_culoare" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Scăzută (0.2)" Value="0.2" />
                                    <asp:ListItem Text="Medie (0.5)" Value="0.5" Selected="True" />
                                    <asp:ListItem Text="Ridicată (0.8)" Value="0.8" />
                                    <asp:ListItem Text="Foarte Ridicată (1.0)" Value="1.0" />
                                </asp:DropDownList>
                            </div>

                            <div class="form-group">
                                <label style="font-size: 0.85rem; font-weight: 600;">🧩 Textură</label>
                                <asp:DropDownList ID="ddl_textura" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Scăzută (0.2)" Value="0.2" />
                                    <asp:ListItem Text="Medie (0.5)" Value="0.5" Selected="True" />
                                    <asp:ListItem Text="Ridicată (0.8)" Value="0.8" />
                                    <asp:ListItem Text="Foarte Ridicată (1.0)" Value="1.0" />
                                </asp:DropDownList>
                            </div>

                            <div class="form-group">
                                <label style="font-size: 0.85rem; font-weight: 600;">⭐ Formă</label>
                                <asp:DropDownList ID="ddl_forma" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Scăzută (0.2)" Value="0.2" />
                                    <asp:ListItem Text="Medie (0.5)" Value="0.5" Selected="True" />
                                    <asp:ListItem Text="Ridicată (0.8)" Value="0.8" />
                                    <asp:ListItem Text="Foarte Ridicată (1.0)" Value="1.0" />
                                </asp:DropDownList>
                            </div>

                            <div class="form-group">
                                <label style="font-size: 0.85rem; font-weight: 600;">📍 Locație</label>
                                <asp:DropDownList ID="ddl_locatie" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Scăzută (0.2)" Value="0.2" />
                                    <asp:ListItem Text="Medie (0.5)" Value="0.5" Selected="True" />
                                    <asp:ListItem Text="Ridicată (0.8)" Value="0.8" />
                                    <asp:ListItem Text="Foarte Ridicată (1.0)" Value="1.0" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <asp:Button ID="btn_cauta_similar" runat="server" 
                            Text="🔍 Găsește Poze Similare" 
                            CssClass="btn btn-primary w-100 mb-3" 
                            OnClick="btn_cauta_similar_Click" />

                        <asp:Label ID="lbl_similar_result" runat="server" CssClass="alert alert-info"></asp:Label>
                    </div>

                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-search"></i>
                            Căutare după Cuvinte Cheie
                        </div>

                        <div class="form-group">
                            <label class="form-label">Caută în Descrieri și Tag-uri</label>
                            <asp:TextBox ID="tb_text_query" runat="server" CssClass="form-control" 
                                placeholder="Ex: mare, munte, petrecere, București..."></asp:TextBox>
                        </div>

                        <asp:Button ID="btn_search_text" runat="server" Text="🔎 Caută în Galerie" 
                            CssClass="btn btn-success w-100 mb-3" OnClick="btn_search_text_Click" />

                        <div id="results" runat="server" class="search-results" style="background: white; border-radius: 18px; padding: 2rem; margin-top: 1.5rem; border: 2px solid #e2e8f0; min-height: 150px;"></div>
                    </div>
                </div>

                <!-- ML Section -->
                <div class="section" id="ml">
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-robot"></i>
                            Detectare Automată cu Inteligență Artificială
                        </div>

                        <p style="color: #64748b; margin-bottom: 2rem; font-size: 1.05rem; line-height: 1.7;">
                            Încarcă o fotografie și modelul nostru de <strong>Machine Learning</strong> va identifica automat ce conține: 
                            obiecte, animale, peisaje și multe altele!
                        </p>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-image"></i> Selectează imaginea pentru analiză
                            </label>
                            <asp:FileUpload ID="FileUploadML" runat="server" CssClass="form-control" />
                        </div>

                        <asp:Button ID="btn_analyze_ml" runat="server" 
                            Text="🤖 Analizează cu AI"
                            CssClass="btn btn-primary w-100 mb-3"
                            OnClick="btn_analyze_ml_Click" />

                        <asp:Label ID="lbl_ml_result" runat="server" CssClass="alert alert-info" Visible="false" />

                        <div style="margin-top:2rem;text-align:center;">
                            <asp:Image ID="img_ml_preview" runat="server" Visible="false"
                                Style="max-width:100%;max-height:550px;border-radius:20px;box-shadow:0 12px 32px rgba(0,0,0,0.18);" />
                        </div>
                    </div>
                </div>

                <!-- Settings Section -->
                <div class="section" id="settings">
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-cog"></i>
                            Setări Sistem
                        </div>

                        <p style="color: #64748b; margin-bottom: 2rem; font-size: 1.05rem; line-height: 1.7;">
                            Generează semnături digitale pentru toate imaginile din baza de date. 
                            Acest proces îmbunătățește viteza căutării prin similaritate.
                        </p>

                        <asp:Button ID="GenerareSemnaturi" runat="server" 
                            Text="🔐 Generează Semnături pentru Toate Imaginile" 
                            CssClass="btn btn-danger w-100" OnClick="GenerareSemnaturi_Click" />
                    </div>
                </div>
            </main>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const menuLinks = document.querySelectorAll('.menu-link');
            const sections = document.querySelectorAll('.section');
            const hdnActiveSection = document.getElementById('<%= hdnActiveSection.ClientID %>');

            // Restaurează secțiunea activă după postback
            const activeSection = hdnActiveSection.value || 'dashboard';
            showSection(activeSection);

            // Handler pentru click-uri pe meniu
            menuLinks.forEach(link => {
                link.addEventListener('click', function (e) {
                    e.preventDefault();
                    const sectionId = this.getAttribute('data-section');
                    hdnActiveSection.value = sectionId;
                    showSection(sectionId);
                });
            });

            // Funcție pentru afișarea secțiunii
            function showSection(sectionId) {
                menuLinks.forEach(l => l.classList.remove('active'));
                const activeLink = document.querySelector(`[data-section="${sectionId}"]`);
                if (activeLink) activeLink.classList.add('active');
                sections.forEach(s => s.classList.remove('active'));
                const section = document.getElementById(sectionId);
                if (section) section.classList.add('active');
            }
        });

        // Album filtering functions
        function filterByTag(tag) {
            document.getElementById('<%= tb_text_query.ClientID %>').value = tag;
            document.getElementById('<%= hdnActiveSection.ClientID %>').value = 'search';
            document.getElementById('<%= btn_search_text.ClientID %>').click();
        }

        function showAllPhotos() {
            document.getElementById('<%= hdnActiveSection.ClientID %>').value = 'gallery';
            document.getElementById('<%= btn_afiseaza_toate.ClientID %>').click();
        }
    </script>
</body>
</html>