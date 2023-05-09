# Instalacion en Arch Linux

**Compilador**
```bash
sudo pacman -S aarch64-linux-gnu-gcc
```

**Emulador**
```bash
sudo pacman -S qemu-system-aarch64
```

Sera necesario una herramienta que permita ver la pantalla de la  
emulación de la Raspberry Pi que se esta ejecutando en QEMU.

```bash
sudo pacman -S tigervnc
```
*Instalar con todas las dependencias necesarias*

## Uso

El archivo _Makefile_ contiene lo necesario para compilar. 

**Para correr el proyecto ejecutar**

```bash
make run
```
Esto construirá el código y ejecutará qemu para su emulación.

Se debe observar la salida de ```make run``` ya que puede cambiar el canal del servidor VNC  
por ejemplo  

```bash 
$ make run
qemu-system-aarch64 -M raspi3b -kernel kernel8.img -serial stdio
VNC server running on ::1:5901
```

Implica tener otra consola en el mismo directorio y inmediatamente hacer
```bash
vncviewer :5901
```
Para ver la ventana ```640 x 480```  
