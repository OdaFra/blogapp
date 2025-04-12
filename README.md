# 📱 BlogApp - Aplicación Flutter

![Flutter](https://img.shields.io/badge/Flutter-3.16-blue)
![Dart](https://img.shields.io/badge/Dart-3.5-blue)
![Supabase](https://img.shields.io/badge/Supabase-2.8-green)

Aplicación móvil de blog desarrollada con Flutter utilizando arquitectura limpia y gestión de estado con BLoC.

## 🚀 Características principales

- 📝 Creación y gestión de posts de blog
- 🔐 Autenticación de usuarios con Supabase
- 🌐 Sincronización en tiempo real
- 📷 Subida de imágenes con Image Picker
- 📱 Diseño responsive y moderno
- 🔄 Sincronización offline con Hive/Isar
- 🧩 Arquitectura modular y escalable

## 📦 Dependencias principales

| Paquete | Versión | Uso |
|---------|---------|-----|
| flutter_bloc | ^9.0.0 | Gestión de estado |
| supabase_flutter | ^2.8.3 | Backend como servicio |
| hive | ^4.0.0-dev.2 | Almacenamiento local |
| isar_flutter_libs | ^4.0.0-dev.13 | Base de datos local |
| image_picker | ^1.1.2 | Selección de imágenes |
| dotted_border | ^2.1.0 | Elementos UI decorativos |
| fpdart | ^1.1.1 | Programación funcional |

## 🛠️ Configuración

### Requisitos previos

- Flutter 3.16 o superior
- Dart 3.5 o superior
- Cuenta en Supabase
- Android Studio/Xcode (para desarrollo nativo)

### Pasos de instalación

#### Clonar el repositorio

```bash
git clone https://github.com/tuusuario/blogapp.git
cd blogapp

# Instalar dependencias:

flutter pub get

#Configurar variables de entorno, se debe crear el archivo .env
touch .env

SUPABASE_URL=tu_url_supabase
SUPABASE_KEY=tu_key_anon_publica
```

## ⚙️ Estructura del proyecto

```bash
lib/
├── core/
│   ├── constants/      # Constantes de la aplicación
│   ├── errors/         # Manejo de errores personalizados
│   ├── usecases/       # Casos de uso centrales
│   ├── utils/          # Utilidades compartidas
│   └── widgets/        # Widgets reutilizables
├── features/
│   ├── auth/           # Autenticación (login, registro)
│   │   ├── bloc/       # Lógica de estado
│   │   ├── models/     # Modelos de datos
│   │   ├── views/      # Pantallas
│   │   └── widgets/    # Componentes UI
│   ├── posts/          # Gestión de posts
│   └── profile/        # Perfil de usuario
├── injection.dart      # Configuración de inyección de dependencias
└── main.dart           # Punto de entrada principal
```

## 🏗️ Arquitectura

La aplicación sigue los principios de **Clean Architecture** con:

### **Capa de Presentación**

- 🖼️ Widgets (Stateless/Stateful)
- 🧩 BLoC para gestión de estado
- 💉 Inyección de dependencias con GetIt

### **Capa de Dominio**

- 🏛️ Entidades centrales
- 🎯 Casos de uso
- 📜 Contracts/Interfaces

### **Capa de Datos**

- 📦 Repositorios implementados
- 🌐 Fuentes de datos (Supabase API + Local DB)
- 🔄 DTOs y mapeadores

---

## 🚦 Ejecución

**Para ejecutar en modo desarrollo**:

```bash
flutter run
```
