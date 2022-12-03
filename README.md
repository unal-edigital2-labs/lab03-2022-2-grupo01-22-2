Una vez se tenga claro qué periféricos debe tener el proyecto, realizar:
1. Descripción de cada periférico, definir las interconexión de entradas y salidas. (caja negra)
2. Describir de forma general el funcionamiento de cada bloque en HW y describir en pseudocódigo la interconexión con el SW.
3. Realizar el mapa de memoria del SoC y de cada periférico.
4. Realizar el diagrama del Soc con los periféricos
## Introducción

La tasa de inseguridad en la ciudad de Bogotá ha estado en aumento en los últimos años afectando tanto a los ciudadanos del común como a los empresarios, por esto se hace menester mitigar este efecto, lo que se puede lograr con ayudas tecnológicas. por lo que se propone el proyecto de un dispositivo seguidor de movimiento por medio de un módulo de cámara de arduino, el movimiento está dado por servomotores y montado sobre una tarjeta Nexys 4 y una  arquitectura de SoC. 

## Mapa de memoria

En el mapa de memoria se puede encontrar la organización inicial de los registros que se planean usar para el funcionamiento del dispositivo 

<p align="center">
<img src="mapmem.png" width="300">
</p>

<p align="center">
<img src="Diagrama.png" width="300">
</p>



## Procesos:



### Módulos:

#### Controladores de servomotor:

En este caso se utilizaron dos servomotores los cuales dan dos ejes de movimiento a nuestra cámara. El servomotor es un actuador rotativo que precisa la posición angular que un motor normal no haría, implementando la retroalimentación de posición.

El control de nuestro servomotor lo realizaremos mediante un PWM conocido por sus siglas en inglés, que funciona enviando un pulso eléctrico de ancho variable o modulación de ancho de pulso a cierta frecuencia. El servomotor viene dado para un pulso cada cierto tiempo, pero al modificar el ancho del pulso puedo determinar hasta donde gira el motor. Nos importe implementar una rotación de 180° por cada uno de los servomotores.Se mantiene al servo en un estado cero es decir que este mantiene la misma cantidad de rotación que nuestra señal CLK definida, y a medida que se van detectando los objetos la rotación de los servomotores empieza aumentar.

El PWM también se utilizó para sincronizar la frecuencia de ambos servomotores. Al momento de compilar el PWM en el litex, desde el Software se sale de la memoria, puesto que la compilación por Hardware si funciona. 

Para seleccionar el pin usado se usa la linea de código en la targeta
```
("pwm__", 1, Pins("E6"), IOStandard("LVCMOS33")),
```
Luego  para instanciarlo en el buildSoCproject.py 

```

SoCCore.add_csr(self,"PWM")
self.submodules.PWM = pwm.PWM(platform.request("pwm__",1))
 

```


### Modulo de camara OV7670

El modulo de camara OV7670 posee un sensor de imagen CMOS VGA OV7670, capaz de trabajar a un máximo de 30 fps (cuadros por segundo) a una resolución de 640x480 pixeles (0.3MPx). Es un SoC (sistema en chip) por lo que es capaz de realizar procesamiento de imágenes, como: control de exposición, gamma, balance de blancos, saturación de color, control de tono (hue). Estos parámetros son configurables mediante la interfaz SCCB (Bus de Control de Cámara Serial). El sensor incluye filtros propios de eliminación de ruido eléctrico, fixed pattern noise (FPN), smearing, blooming, etc. 

Para la cámara  se implementó el control I2C con ayuda de un Arduino para leer los datos de la cámara y ser procesados después por el Hardware. Los datos iban a ser procesados por la UART implementando la FPGA; por comunicación por medio de pilas de datos. El funcionamiento no se logro totalmente pro un problema en la asignación de los pines de la tarjeta, los constraints, creemos que con mas tiempo hubiéramos podido detallar este tipo de errores.

Instanciandolo se tenia

```
       SoCCore.add_csr(self,"i2c_master")
       self.submodules.i2c_master = bitbang.I2CMaster()

```



### Procesamiento de imagen para object tracking

Se logró una  “visión artificial”  por medio de la librería openCV en Python, la cual detecta objetos en movimiento. El proceso comienza por aplicar al video una binarización, la que se puede describir como un filtro que dependiendo de un umbral seleccionado convierte los pixeles a blanco o negro, luego comparando con los frames anteriores se detectan los objetos en movimiento y se separan del fondo.

```
fgbg = cv2.bgsegm.createBackgroundSubtractorMOG2(history=3, varThreshold=50, detectShadows=False)

```


Por último, en cada frame, se señala el objeto con un rectángulo  

```
# Obtenemos el bounds() del contorno, el rectángulo mayor que engloba al contorno
       (x, y, w, h) = cv2.boundingRect(c)
       # Dibujamos el rectángulo del bounds
       cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
       l.append((x + w) * (y + h))

```


En nuestro caso, para simplificar solamente se uso el rectangulo mas grande detectado 

```
# Usar el rectangulo mas grande
       if l[-1] == max(l):
           cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), 2)

```

Se planea enviar estas coordenadas por medio de un serial a la FPGA pero por tiempo no se implementó 

 
### Montaje físico

Para diseñar la estructura del dispositivo se usó un programa de modelado 3d open source llamado FreeCad, obteniendo 4 piezas

<p align="center">
<img src="mod3d.png" width="300">
</p>

### Diseño 

Se penso en los perisfericos necesarios para el proyecto en este caso inicialmente la camara, servomotores y uno o dos uarts, uno que permita la comunicación con la camara y otro la comunicación con el computador en caso de que se requiera procesar la imagen fuera de la FPGA.
img   
….
.
.
.
img

Para la implementación adicional a los periféricos ya implementados como los botones o los switches, se agregaron principalmente: PWM, por medio de la función que Litex ya tiene incluida, una uart adicional para realizar la lectura de datos desde el módulo de arduino que, principalmente recibe los información de la cámara por medio de protocolo I2C que el arduino recibe para poder transmitirlos a la FPGA por medio de la uart

# Software

Inicialmente para la detección de objetos se utilizó la librería de Python OpenCV, luego para la implementación se encontraron diversos obstáculos, como el hecho de que el firmware esta en C por lo que se debe traducir entre lenguajes. Otra alternativa que se pensó fue realizar el procesamiento de reconocimiento de la imagen en el computador para poder usar la librería Opencv y transmitir la información por medio de otro puerto uart


### Hardware 

A nivel de Hardware se realizo la implementación por Litex, sin embargo nunca llego a correrse. Se cree que se debe a errores dentro del Software de cada uno de los periféricos  
