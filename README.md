# SoC_initial

1. instalar litex https://github.com/enjoy-digital/litex
2. Descargar el paquete WP04
3. ingresar en un terminal a la carpeta ´SoC_project´
4. ejecutar "python3 buildSoCproject.py"
5. djtgcfg prog -d NexysA7 -i 0 -f ./build/nexys4ddr/gateware/nexys4ddr.bit
6. ir a la carpeta  firmware
7. ejecutar "make all"
8. salir de la carpeta firmware  
9. ejecutar litex_term.py /dev/ttyUSB1 --kernel firmware/firmware.bin
10.  enteder el programa que esta  ejecutando el procesardor 

# Diseño 

  Se penso en los perisfericos necesarios para el proyecto en este caso inicialmente la camara, servomotores y uno o dos uarts, uno que permita la comunicación con la camara y otro la comunicación con el computador en caso de que se requiera procesar la imagen fuera de la FPGA.
  
  ![img2](https://github.com/unal-edigital2-labs/ProyectoGr3/blob/main/Captura%20de%20pantalla%20de%202022-11-01%2000-41-19.jpg)

Para la implementación adicional a los perifericos ya implementados como los botones o los switches, se agregaron principalmente: PWM, por medio de la funcion que Litex ya tiene incluida, una uart adicional para realizar la lectura de datos desde el modulo de arduino que, principalmente recibe los información de la camara por medio de protocolo I2C que el arduino recibe para poder trasmitirlos a la FPGA por medio de la uart.

# Software 

Inicialmente para la detección de objetos se utilizo la libreria de Python OpenCV, luego para la omplementación se encotraron diversos obstaculos, como el hecho de que el fimware esta en C por lo que se debe traducir entre lenguajes. Otra alternativa que se penso fue realizar el procesamiento de reconocimiento de la imagen en el computador para poder usar la libreria Open CV y trasmitir la información por medio de otro puerto uart 
