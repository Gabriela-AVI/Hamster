# 🐹 MICA ✨

⭐ MICA es un juego 2D de tipo plataformas desarrollado en Godot 4, donde controlas a la propia hámster Mica. 
Todo esto mediante saltos, dash y movimientos rápidos. Tu misión es recoger todas las pipas posibles, evitar trampas, 
esquivar enemigos y alcanzar la puerta de su querido invernadero. 

⭐ Se encuentra **activo y en continua mejora**.

---
## 🎯Instalación del juego
### Librerías utilizadas:
- pip install djangorestframework
- pip install djangorestframework-simplejwt
  
### Servidor se encuentra en **MicaDjango/micaserver**:
- python manage.py runserver

---
## 📋 Requisitos
1. [Jugador](#jugador)
2. [Enemigos](#enemigos)
3. [Complejidad de Escenas](#complejidad-de-escenas)
4. [Número de Escenas](#número-de-escenas)
5. [Bonificaciones y Coleccionables](#bonificaciones-y-coleccionables)
6. [Funciones de red](#funciones-de-red)
7. [Sonido](#sonido)
8. [Opciones](#opciones)
9. [Estética y jugabilidad](#estética-y-jugabilidad)
   
---
  ## 🐹Jugador 
  * Movimiento multidireccional
  * Acciones especiales (saltar, rodar…)
  * Uso del ratón con procesamiento de coordenadas.

  ## 👾Enemigos
  Dos tipos de enemigos que llevan a cabo acciones sencillas:
  - Ratón de campo
  - Avispa

  ## 🖼️Complejidad de Escenas
  Entorno transitable con interacciones y animaciones.

  ## 🎞️Número de Escenas
  Cuenta con 3 niveles que van aumentando su dificultad.
  
  ## 🪙Bonificaciones y Coleccionables
  Existen dos tipos de elementos interactivos que son recogibles por el jugador:
  - Pipas
  - Vida extra

  ## 🛜Funciones de red
  (POST) | Publicar nombre del jugador, tiempo y puntuaciones.
  (GET)  | Obtener y mostrar las puntuaciones en un scoreboard.

  ## 🔊Sonido
  Elaborado ya que existen:
  - 2 efectos de sonido simples que tienen lugar ante ciertos eventos del juego (Al recibir daño y al abrir la puerta final)
  - 3 canciones de fondo (cada 1 en un nivel distinto)

  ## 🎛️Opciones
  Existe un menú de opciones que permite configurar (todas ellas se almacenan en un fichero):
  - Nombre de usuario
  - Volumen
  - Panatalla completa
    
  ## 🕹️Estética y jugabilidad
  Buena calidad porque está hecha con amor (y con muchos lloros).

---
🌸Persona Desarrolladora del Proyecto:   **G.A.V.I.**  


