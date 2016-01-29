/*
*
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*
*/

#include <main.h>
#include <stm32f4xx.h>

//Quick hack, approximately 1ms delay
void ms_delay(int ms) {
   while (ms-- > 0) {
      volatile int x=5971;
      while (x-- > 0)
         __asm("nop");
   }
}
int main() {
   // Enable GPIOA clock.
   RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
   // Configure GPIOA pin 5 as output.
   GPIOA->MODER |= (1 << (LED_PIN << 1));
   // Configure GPIOA pin 5 in max speed.
   GPIOA->OSPEEDR |= (3 << (LED_PIN << 1));
   LED_ON();
   ms_delay(1000);
   LED_OFF();
   ms_delay(1000);

  // Blink LED.
  while(1) {
     for(int n=0;n<10;n++){
        ms_delay(70);
        LED_TOGGLE();
     }
  ms_delay(1000);
  }
}
