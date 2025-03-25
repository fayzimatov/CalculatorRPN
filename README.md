# 📱 RPN Calculator

Этот проект – калькулятор, использующий алгоритм [Shunting-yard](https://en.wikipedia.org/wiki/Shunting-yard_algorithm).  
Сначала выражение переводится в обратную польскую нотацию (RPN), после чего выполняется вычисление.  
Проект реализован с использованием архитектуры **MVVM**.

## 🎨 Скриншоты

### 🔹 Экран загрузки (Launch Screen)
<img src="RPNCalculator/Images/launch_screen.png" width="300">

### 🔹 Главный экран
**Светлая тема:**  
<img src="RPNCalculator/Images/main_screen_LightMode.png" width="300">

**Тёмная тема:**  
<img src="RPNCalculator/Images/main_screen_DarkMode.png" width="300">

### ✅ Примеры вычислений  
<img src="RPNCalculator/Images/example1.png" width="300">  
<img src="RPNCalculator/Images/example2.png" width="300">  

## 🔹 Функциональность  
- **Кнопка удаления**  
  - Одно нажатие — удаляет один символ.  
  <img src="RPNCalculator/Images/remove_button.png" width="300">  
  - Долгое нажатие — очищает всю строку.  

- **Кнопка отрицательного числа (±)**  
  - Первое нажатие делает число отрицательным.  
  <img src="RPNCalculator/Images/negate_button.png" width="300">  
  - Второе нажатие меняет обратно на положительное.

- **Поддерживаемые операции:** `+`, `-`, `×`, `÷`, `()`.

- **Обработка ошибок:**  
  - Деление на `0` отображает `Неопределено`.  
  <img src="RPNCalculator/Images/undefined.png" width="300">  
  - `0 ÷ 0` → `Бесконечность`.  
  <img src="RPNCalculator/Images/infinity.png" width="300">  

## 🚀 Установка  
1. Клонируйте репозиторий:  
   ```sh
   git clone https://github.com/username/CalculatorRPN.git
   ```

## 🛠 Технологии

- **Swift**  
- **MVVM**  
- **UIKit**  
