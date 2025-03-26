# 📱 RPN Calculator

Этот проект – калькулятор, использующий алгоритм [Shunting-yard](https://en.wikipedia.org/wiki/Shunting-yard_algorithm).  
Сначала выражение переводится в обратную польскую нотацию (RPN), после чего выполняется вычисление.  
Проект реализован с использованием архитектуры **MVVM**.

## 🎨 Скриншоты

### 🔹 Экран загрузки (Launch Screen)
<img src="Images/launch_screen.png" width="300">

### 🔹 Главный экран
**Светлая тема:**  
<img src="Images/main_screen_LightMode.png" width="300">

**Тёмная тема:**  
<img src="Images/main_screen_DarkMode.png" width="300">

### ✅ Примеры вычислений  
<img src="Images/example1.png" width="300">  
<img src="Images/example2.png" width="300">  

## 🔹 Функциональность  
- **Кнопка удаления**  
  - Одно нажатие — удаляет один символ.  
  <img src="Images/remove_button.png" width="300">

  - Долгое нажатие — очищает всю строку.  

- **Кнопка отрицательного числа (±)**  
  - Первое нажатие делает число отрицательным.
  - Второе нажатие меняет обратно на положительное.
  <img src="Images/negate_button.png" width="300">


- **Поддерживаемые операции:** `+`, `-`, `×`, `÷`, `()`.

- **Обработка ошибок:**  
  - Деление на `0` отображает `Неопределено`.  
  <img src="Images/undefined.png" width="300">

  - `0 ÷ 0` → `Бесконечность`.  
  <img src="Images/infinitiv.png" width="300">  

## 🚀 Установка  
1. Клонируйте репозиторий:  
   ```sh
   git clone https://github.com/username/CalculatorRPN.git
   ```

## 🛠 Технологии

- **Swift**  
- **MVVM**  
- **UIKit**  
