#include <GL/freeglut.h>
#include <stdio.h>

void DrawRectWithPoints() {
  glColor3f(1.0F, 0.0F, 0.0F);
  glBegin(GL_LINES);
  glVertex3d(-0.5F, -0.5F, 0.0F);
  glVertex3d(+0.5F, -0.5F, 0.0F);

  glVertex3d(+0.5F, -0.5F, 0.0F);
  glVertex3d(+0.5F, +0.5F, 0.0F);

  glVertex3d(+0.5F, +0.5F, 0.0F);
  glVertex3d(-0.5F, +0.5F, 0.0F);

  glVertex3d(-0.5F, +0.5F, 0.0F);
  glVertex3d(-0.5F, -0.5F, 0.0F);

  glEnd();
}

void display(void) {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);  // 清除当前缓冲区
  DrawRectWithPoints();
  glFlush();
}

void init(void) {
  glClearColor(0.0F, 0.0F, 0.0F, 0.0F);  // 设置清除颜色为黑色，用于清除RGBA模式下的颜色缓冲区
  glClearDepth(1.0);                     // 设置深度缓冲区中每个像素需要的深度值
}

void reshape(int w, int h) {
  glViewport(0, 0, static_cast<GLsizei>(w), static_cast<GLsizei>(h));
  printf("%20s, w = %d, h = %d\n", __func__, w, h);
}

void keyboard(unsigned char key, int x, int y) {
  printf("%20s, x = %d, y = %d, key = %c\n", __func__, x, y, key);
  //
}

void mouse(int button, int state, int x, int y) {
  printf("%20s, x = %d, y = %d, button = %d, state = %d\n", __func__, x, y, button, state);
  //
}

void motion(int x, int y) {
  printf("%20s, x = %d, y = %d\n", __func__, x, y);
  //
}

void position(int x, int y) {
  printf("%20s, x = %d, y = %d\n", __func__, x, y);
  //
}

int main(int argc, char** argv) {
  // 在调用其他任何GLUT函数之前首先要调用这个函数，它对GLUT函数库进行初始化。它还会对命令行选项进行处理，但处理的选项因窗口系统而异。
  glutInit(&argc, argv);

  /* 指定glutCreateWindow()函数将要创建的串口的显示模式（例如使用RGBA还是颜色索引、使用单缓冲区还是双缓冲区等）
   * mode参数是一个GLUT库里预定义的可能的布尔组合。用于指定颜色模式，数量和缓冲区类型。
   * 其中大部分情况下使用的参数为：GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH | GLUT_STENCIL
   * 颜色模式  ：GLUT_RGBA表示颜色模式，另外还有GLUT_RGB 和 GLUT_INDEX模式。
   * 缓冲区类型：GLUT_DOUBLE表示使用双缓冲窗口，与之对应的是GLUT_SINGLE模式，二者的区别是：
   *  单缓冲  :实际上就是将所有的绘图指令在窗口上执行，就是直接在窗口上绘图，这样的绘图效率是比较慢的，
   *          如果使用单缓冲，而电脑比较慢，屏幕会发生闪烁。一般只用于显示单独的一副非动态的图像。
   *  双缓冲
   * :实际上的绘图指令是在一个缓冲区完成，这里的绘图非常的快，在绘图指令完成之后，再通过交换指令把完成的图形立即显示在屏幕上，
   *          这就避免了出现绘图的不完整，同时效率很高。一般用于生成动画效果。
   * 其它的缓冲模式还有很多例如:
   * 值               对应宏定义  意义
   * GLUT_RGB         0x0000    指定RGB颜色模式的窗口
   * GLUT_RGBA        0x0000    指定RGBA颜色模式的窗口
   * GLUT_INDEX       0x0001    指定颜色索引模式窗口
   * GLUT_SINGLE      0x0000    指定单缓存窗口
   * GLUT_DOUBLE      0x0002    指定双缓存窗口
   * GLUT_ACCUM       0x0004    窗口使用累加缓存
   * GLUT_ALPHA       0x0008    窗口的颜色分量包含ALPHA值
   * GLUT_DEPTH       0x0010    窗口使用深度缓存
   * GLUT_STENCIL     0x0020    窗口使用模板缓存
   * GLUT_MULTISAMPLE 0x0080    指定支持多样本功能的窗口
   * GLUT_STEREO      0x0100    指定立体窗口
   * GLUT_LUMINANCE   0x0200    窗口使用亮度颜色模型
   */
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH);
  glutInitWindowSize(800, 800);      // 指定窗口的大小（以像素为单位）
  glutInitWindowPosition(100, 100);  // 指定窗口左上角的屏幕位置
  glutInitContextVersion(3, 0);      // 声明了要使用 OpenGL 版本
  glutCreateWindow("hello");

  init();

  // 指定了当窗口的内容需要进行重绘时将要调用的函数。在发生下面这些情况时，窗口就需要进行重绘。
  // 窗口刚打开、窗口弹出、窗口的内容遭到破坏，以及显示调用glutPostRedisplay()函数
  glutDisplayFunc(display);

  // 指定了当窗口大小被改变或者当窗口被移动时要调用的函数。
  // 一般情况下，回调函数调用glViewPort()函数，使显示区域被裁减为新的大小，并且对投影矩阵进行
  // 重新定义，使被投影图像的纵横比与视口相匹配，从而避免了纵横比的变形。如果调用或指定参数为NULL
  // 则调用默认的窗口改变函数，即glViewPort(0, 0, width, height)
  glutReshapeFunc(reshape);

  // 当一个能够生成ASCII字符的按键按下时执行的函数
  glutKeyboardFunc(keyboard);
  glutMouseFunc(mouse);
  glutMotionFunc(motion);
  glutPositionFunc(position);
  glutMainLoop();

  return EXIT_SUCCESS;
}
