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
/*
#define LED_PIN 5

#define GPIO_PIN_0		((uint16_t)0x0001)
#define GPIO_PIN_1		((uint16_t)0x0002)
#define GPIO_PIN_2		((uint16_t)0x0004)
#define GPIO_PIN_3		((uint16_t)0x0008)
#define GPIO_PIN_4		((uint16_t)0x0010)
#define GPIO_PIN_5		((uint16_t)0x0020)
#define GPIO_PIN_6		((uint16_t)0x0040)
#define GPIO_PIN_7		((uint16_t)0x0080)
#define GPIO_PIN_8		((uint16_t)0x0100)
#define GPIO_PIN_9		((uint16_t)0x0200)
#define GPIO_PIN_10		((uint16_t)0x0400)
#define GPIO_PIN_11		((uint16_t)0x0800)
#define GPIO_PIN_12		((uint16_t)0x1000)
#define GPIO_PIN_13		((uint16_t)0x2000)
#define GPIO_PIN_14		((uint16_t)0x4000)
#define GPIO_PIN_15		((uint16_t)0x8000)
#define GPIO_PIN_ALL	((uint16_t)0xFFFF)

#define GPIO_SetPinLow(GPIOx, GPIO_Pin)			((GPIOx)->BSRR = (uint32_t)((GPIO_Pin) << 16))
#define GPIO_SetPinHigh(GPIOx, GPIO_Pin)			((GPIOx)->BSRR = (uint32_t)(GPIO_Pin))
#define GPIO_TogglePinValue(GPIOx, GPIO_Pin)		((GPIOx)->ODR ^= (GPIO_Pin))


#define LED_TOGGLE() GPIO_TogglePinValue(GPIOA, GPIO_PIN_5)
#define LED_OFF() GPIO_SetPinLow(GPIOA, GPIO_PIN_5)
#define LED_ON() GPIO_SetPinHigh(GPIOA, GPIO_PIN_5)

*/

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
