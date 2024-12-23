Lecto_01/
├── android/                              # Configuración específica para Android
├── ios/                                  # Configuración específica para iOS
├── assets/                               # Recursos estáticos
│   ├── fonts/                            # Fuentes personalizadas
│   └── translations/                     # Archivos de traducción (localización)
├── lib/                                  # Código fuente de la aplicación
│   ├── src/                              # Código fuente
│   │   ├── core/                         # Elementos centrales compartidos
│   │   │   ├── navigation/               # Manejo de navegación
│   │   │   │   ├── app_navigator.dart   # Maneja la navegación de la app
│   │   │   │   └── routes.dart          # Rutas de navegación y recursos estáticos
│   │   │   ├── providers/                # Proveedores de estado
│   │   │   │   └── theme_provider.dart  # Proveedor para el tema de la app
│   │   │   ├── utils/                    # Utilidades generales
│   │   │   │   └── lottie_animations.dart  # Animaciones de Lottie
│   │   ├── features/                     # Funcionalidades específicas de la app
│   │   │   ├── login/                    # Funcionalidad de login
│   │   │   │   ├── login_page.dart      # Página de login
│   │   │   │   └── login_view_model.dart # Lógica de la vista de login
│   │   │   ├── pdf_upload/               # Funcionalidad de carga de PDFs
│   │   │   │   ├── pdf_upload_page.dart  # Página de carga de PDFs
│   │   │   │   └── pdf_upload_view_model.dart # Lógica de la vista de carga
│   │   │   ├── home/                     # Página principal de la app
│   │   │   │   ├── home_page.dart       # Página de inicio
│   │   │   │   └── home_view_model.dart  # Lógica de la vista principal
│   │   │   ├── playback/                 # Funcionalidad de reproducción
│   │   │   │   └── playback_screen.dart  # Página de reproducción
│   │   │   ├── processing/               # Funcionalidad de procesamiento
│   │   │   │   └── processing_screen.dart # Página de procesamiento
│   │   │   └── settings/                 # Funcionalidad de configuración
│   │   │       └── settings_page.dart    # Página de configuración
│   └── main.dart                         # Punto de entrada principal
├── pubspec.yaml                          # Archivo de dependencias y configuración
└── README.md                             # Documentación general del proyecto
