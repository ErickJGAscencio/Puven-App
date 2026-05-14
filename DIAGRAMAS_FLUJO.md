# 📊 Diagramas Visuales: Flujo de Cierre de Caja

## 1️⃣ FLUJO GENERAL DE LA APLICACIÓN

```
┌─────────────────────────────────────────────────────────────┐
│                    APP INICIA                               │
│                                                             │
│  AppPage._loadCashSessionState()                            │
│         ↓                                                    │
│  ¿Hay sesión abierta?                                       │
└─────────────────────────────────────────────────────────────┘
         │
         ├─ NO → ✅ Mostrar "Abrir caja" (disponible en HomePage)
         │
         └─ SÍ → CashService.validateCashSessionState()
                       ↓
              ┌────────────────────┐
              │   VALIDACIONES     │
              └────────────────────┘
              │
              ├─ ¿tipo == "forced"? → Diálogo "Crash"
              │
              ├─ ¿otro día? → Diálogo "Caja desde X"
              │
              ├─ ¿inactividad > 30 min? → Diálogo "Inactividad"
              │
              ├─ ¿tipo == "temporal"? → Diálogo "Sesión temporal"
              │
              └─ NO → ✅ Abrir normalm

ente
```

---

## 2️⃣ FLUJO DE ACTUALIZACIÓN DE `lastInteraction`

```
                    INTERACCIÓN DEL USUARIO
                              │
                ┌─────────────┼─────────────┐
                ▼             ▼             ▼
          Abre HomePage  Registra venta  Va a otra página
                │             │             │
                ├─────────────┴─────────────┤
                ▼
    CashService.updateLastInteraction()
                │
                ├─ getCashSessionOpened()
                │
                └─ database.updateLastInteraction(id)
                       │
                       └─ UPDATE last_interaction = now()
```

---

## 3️⃣ CÁLCULO CORRECTO DE CIERRE

```
┌──────────────────────────────────────────────┐
│          CIERRE DE CAJA - CÁLCULO            │
└──────────────────────────────────────────────┘

Monto Inicial: $100
├─ Venta 1: $50
├─ Venta 2: $40
└─ Venta 3: $10
   Total Ventas: $100

┌─────────────────────────────┐
│ closingAmount = $200        │  ← Monto inicial + ventas
│ expectedCash = $100         │  ← Solo ventas (esperado)
│ Diferencia = $0             │  ← Varianza (cuadra bien)
└─────────────────────────────┘

❌ ANTES (INCORRECTO):
closingAmount = $300 (sumaba inicial 2 veces)
expectedCash = $200 (restaba inicial)
Diferencia = $100 (no cuadraba)

✅ DESPUÉS (CORRECTO):
closingAmount = openingAmount + totalSales
expectedCash = totalSales
Diferencia = 0 (o lo que no viene de ventas)
```

---

## 4️⃣ ESTADOS DE UNA SESIÓN DE CAJA

```
┌─────────────────────────────────────────────────┐
│           ESTADO = "open" (La caja sigue abierta)
├─────────────────────────────────────────────────┤
│                                                 │
│  TYPE = "wait"                                  │
│  └─ Sesión normal, sin problemas                │
│     └─ Usuario interactuando                    │
│                                                 │
│  TYPE = "temporal"                              │
│  └─ Inactividad > 30 min                        │
│     └─ Usuario NO está interactuando            │
│                                                 │
│  TYPE = "forced"                                │
│  └─ App se cerró inesperadamente               │
│     └─ User fue desconectado violentamente      │
│                                                 │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│           ESTADO = "closed" (La caja se cerró)  │
├─────────────────────────────────────────────────┤
│                                                 │
│  TYPE = "normal"                                │
│  └─ Cierre intencional por el usuario           │
│                                                 │
│  TYPE = "temporal"                              │
│  └─ Cierre por inactividad                      │
│                                                 │
│  TYPE = "forced"                                │
│  └─ Cierre inesperado (app se cerró)           │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## 5️⃣ VALIDACIÓN DE SESIÓN AL INICIAR

```
                    APP INICIA
                         │
              getCashSessionOpened()
                         │
            ┌────────────┴────────────┐
            │                         │
        NULL ✅                    SESSION
            │                     (cashSession)
            │                         │
      No hay caja             ¿qué hora es?
      abierta                         │
                         ┌───────────┬───────────┐
                         │           │           │
                    < 30 min    30-60 min   > 60 min
                         │           │           │
                    ✅ SIN      ⚠️ DIÁLOGO  ⚠️ DIÁLOGO
                   DIÁLOGO      INACTIV.   INACTIV./
                         │           │      OTRO DÍA
                      Abre      Cerrar o  Cerrar o
                     normal    Continuar Continuar
                         │           │           │
                         └───────────┴───────────┘
                                  │
                    updateLastInteraction()
                                  │
                              Abre app
```

---

## 6️⃣ MATRIZ DE MÉTODOS Y UBICACIÓN

```
┌────────────────────────────────────────────────────────────┐
│ MÉTODOS NUEVOS EN database.dart                            │
├────────────────────────────────────────────────────────────┤
│ • updateLastInteraction(id)                                │
│ • getCashSessionsByDay(date)                               │
│ • getLatestOpenCashSession()                               │
│ • updateCashSessionType(id, type)                          │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ MÉTODOS NUEVOS EN cash_service.dart                        │
├────────────────────────────────────────────────────────────┤
│ • updateLastInteraction(db)                                │
│ • validateCashSessionState(db)                             │
│ • markAsTemporalInactivity(db)                             │
│ • Clase CashSessionValidation                              │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ LUGARES DONDE SE LLAMA updateLastInteraction()            │
├────────────────────────────────────────────────────────────┤
│ ✅ home_page.dart - initState (línea 93)                   │
│ ✅ home_page.dart - _saveOrder (línea 1142)                │
│ ✅ app_page.dart - al reanudar sesión                      │
│ ⚠️  my_products_page.dart - PENDIENTE                      │
│ ⚠️  sales_history_page.dart - PENDIENTE                    │
└────────────────────────────────────────────────────────────┘
```

---

## 7️⃣ DECISIÓN DE MOSTRAR DIÁLOGO

```
                    validationResult
                          │
            ┌─────────────┴─────────────┐
            │                           │
        null ✅                   CashSessionValidation
            │                    (hasPendingSession=true)
            │                           │
     Abre                    _showPendingSessionDialog()
     sin                               │
     diálogo                 ┌─────────┴──────────┐
                             │                    │
                          Cerrar              Continuar
                             │                    │
                      closeCash()      updateLastInteraction()
                             │                    │
                      isCashOpen=false      isCashOpen=true
                             │                    │
                         Mostrar            Mostrar
                      "Caja cerrada"     "Punto de venta"
```

---

## 8️⃣ CAMBIOS DE CÓDIGO CLAVE

### ❌ ANTES:
```dart
double closingAmount = 0.0;
for (Order order in orders) {
  closingAmount += order.totalAmount;
}
closingAmount += cashSession.openingAmount; // 🔴 DUPLICADO!
double expectedCash = closingAmount - cashSession.openingAmount;
```

### ✅ DESPUÉS:
```dart
double totalSales = 0.0;
for (Order order in orders) {
  totalSales += order.totalAmount;
}
double expectedCash = totalSales;
double closingAmount = cashSession.openingAmount + totalSales;
```

---

## 9️⃣ TIPOS DE DIÁLOGO A MOSTRAR

```
┌─────────────────────────────────────────────────────────┐
│ DIÁLOGO 1: CIERRE FORZOSO                              │
├─────────────────────────────────────────────────────────┤
│ Icono: ⚠️  WARNING                                      │
│ Color: 🔴 RED                                           │
│ Título: "App se cerró inesperadamente"                  │
│ Mensaje: "La aplicación se cerró inesperadamente.       │
│           La caja está abierta desde X fecha"            │
│ Botones: CERRAR | CONTINUAR                             │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ DIÁLOGO 2: OTRO DÍA                                     │
├─────────────────────────────────────────────────────────┤
│ Icono: 📅 CALENDAR                                      │
│ Color: 🟢 GREEN                                         │
│ Título: "Caja abierta desde otro día"                   │
│ Mensaje: "La caja está abierta desde X fecha            │
│           (hace Y día(s))"                               │
│ Botones: CERRAR | CONTINUAR                             │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ DIÁLOGO 3: INACTIVIDAD                                  │
├─────────────────────────────────────────────────────────┤
│ Icono: 📱 SMARTPHONE                                    │
│ Color: 🟢 GREEN                                         │
│ Título: "Inactividad detectada"                         │
│ Mensaje: "No has entrado a Puven por más de 30 minutos. │
│           Bloqueamos el Punto de Venta por seguridad"   │
│ Botones: CERRAR | CONTINUAR                             │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ DIÁLOGO 4: SESIÓN TEMPORAL                              │
├─────────────────────────────────────────────────────────┤
│ Icono: ⏱️  TIMER                                         │
│ Color: 🟢 GREEN                                         │
│ Título: "Sesión temporal pendiente"                     │
│ Mensaje: "Hay una sesión temporal pendiente"             │
│ Botones: CERRAR | CONTINUAR                             │
└─────────────────────────────────────────────────────────┘
```

---

## 🔟 LÍNEA DE TIEMPO DEL USUARIO

```
09:00 AM
  ↓
Usuario ABRE la app
  ├─ initState() llamado
  ├─ validateCashSessionState() → null (no hay caja)
  └─ Muestra botón "Abrir caja"

09:05 AM
  ↓
Usuario hace CLIC en "Abrir caja"
  ├─ openCash(100) → Crea CashSession
  ├─ lastInteraction = 09:05 AM
  ├─ type = "wait"
  └─ Muestra "Punto de venta"

09:10 AM
  ↓
Usuario REGISTRA VENTA ($50)
  ├─ _saveOrder() → Inserta en BD
  ├─ updateLastInteraction() → lastInteraction = 09:10 AM ✅
  └─ Limpia carrito

10:00 AM (Sin actividad)
  ↓
Usuario CIERRA la app
  ├─ Sesión sigue ABIERTA en la BD
  ├─ type = "wait"
  └─ lastInteraction = 09:10 AM

10:45 AM (55 min después)
  ↓
Usuario ABRE la app nuevamente
  ├─ initState() llamado
  ├─ validateCashSessionState()
  │   ├─ getCashSessionOpened() → Encuentra la sesión
  │   ├─ difference = 55 minutos
  │   ├─ ¿type == "forced"? → NO
  │   ├─ ¿otro día? → NO
  │   ├─ ¿inactividad > 30 min? → SÍ ✅
  │   └─ Retorna validation (type="inactivity")
  │
  ├─ _showPendingSessionDialog(validation)
  │   ├─ Muestra diálogo
  │   └─ Usuario elige...
  │
  ├─ Si CERRAR:
  │   ├─ closeCash() → Cierra sesión
  │   └─ type = "normal"
  │
  └─ Si CONTINUAR:
      ├─ updateLastInteraction() → lastInteraction = 10:45 AM ✅
      ├─ type = "wait" (vuelve a "wait")
      └─ Abre app normalmente
```

---

## Leyenda de Símbolos

```
✅ = Completado/Implementado
⚠️ = Pendiente/Advertencia
❌ = No implementado
🟢 = Verde (positivo)
🔴 = Rojo (negativo)
📁 = Archivo
📝 = Código/Texto
📊 = Datos/Tabla
📱 = Interfaz
📅 = Fecha
⏱️ = Tiempo
```

