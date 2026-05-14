# Guía de Implementación: Actualización de `last_interaction`

## 📍 Ubicaciones Críticas donde se Actualiza `lastInteraction`

### 1. **home_page.dart** - Cuando se Registra una Venta ✅ IMPLEMENTADO
**Ubicación:** `_saveOrder()` - línea ~1140

```dart
// Al final de _saveOrder(), después de guardar la orden
await CashService.updateLastInteraction(database);
```

**Por qué:** Es la interacción más importante - genera dinero.

---

### 2. **home_page.dart** - Cuando se Abre la Página ✅ IMPLEMENTADO
**Ubicación:** `initState()` - línea ~93

```dart
void initState() {
  super.initState();
  database = widget.database;
  productForms.add(ProductFormModel());
  _loadFolio();
  // ✅ Actualizar última interacción cuando se abre la página
  CashService.updateLastInteraction(database);
}
```

**Por qué:** Indica que el usuario está activo en el Punto de Venta.

---

### 3. **my_products_page.dart** - Cuando se Editan/Crean Productos ⚠️ RECOMENDADO

**Ubicación:** En `initState()` de la página

```dart
// Agregar al initState de MyProductsPage
void initState() {
  super.initState();
  // ... tu código existente ...
  
  // ✅ Actualizar última interacción
  CashService.updateLastInteraction(widget.database);
}
```

**Por qué:** El usuario está administrando su inventario.

---

### 4. **sales_history_page.dart** - Cuando se Consulta el Historial ⚠️ RECOMENDADO

**Ubicación:** En `initState()` de la página

```dart
// Agregar al initState de SalesHistoryPage
void initState() {
  super.initState();
  // ... tu código existente ...
  
  // ✅ Actualizar última interacción
  CashService.updateLastInteraction(widget.database);
}
```

**Por qué:** El usuario sigue usando el sistema.

---

### 5. **app_page.dart** - Cuando se Continúa Sesión Pendiente ✅ IMPLEMENTADO

**Ubicación:** `_loadCashSessionState()` - línea ~76

```dart
if (shouldContinue) {
  // Actualizar la última interacción al reanudar
  await CashService.updateLastInteraction(database);
  
  setState(() {
    isCashOpen = true;
  });
}
```

**Por qué:** Reinicia el contador de inactividad cuando el usuario reanuda.

---

### 6. **Cambios en Cantidad/Precio** ⚠️ OPCIONAL

Si tienes métodos que actualicen cantidad o precio en el carrito, también deberías agregar:

```dart
// En cualquier método que modifique el carrito
await CashService.updateLastInteraction(database);
```

---

## 🔄 Flujo Completo de Actualización

```
APP INICIA
    ↓
├─ AppPage._loadCashSessionState()
│  └─ CashService.validateCashSessionState()
│     ├─ Si hay sesión pendiente → Mostrar diálogo
│     └─ Si usuario continúa → updateLastInteraction() ✅
│
├─ Usuario navega a HomePage
│  └─ HomePage.initState()
│     └─ updateLastInteraction() ✅
│
├─ Usuario registra venta
│  └─ HomePage._saveOrder()
│     └─ updateLastInteraction() ✅
│
├─ Usuario navega a MyProductsPage
│  └─ MyProductsPage.initState()
│     └─ updateLastInteraction() ✅
│
├─ Usuario navega a SalesHistoryPage
│  └─ SalesHistoryPage.initState()
│     └─ updateLastInteraction() ✅
│
└─ Después de 30 min de inactividad
   └─ validación fallida → Mostrar diálogo
```

---

## 🗂️ Matriz de Implementación

| Página/Método | Ubicación | Estado | Próximos Pasos |
|---------------|-----------|--------|---|
| HomePage.initState | home_page.dart | ✅ Hecho | - |
| HomePage._saveOrder | home_page.dart | ✅ Hecho | Probar |
| MyProductsPage.initState | my_products_page.dart | ⚠️ Pendiente | Implementar |
| SalesHistoryPage.initState | sales_history_page.dart | ⚠️ Pendiente | Implementar |
| AppPage al continuar | app_page.dart | ✅ Hecho | - |
| Cambios en carrito | home_page.dart | ⚠️ Opcional | Considerar |

---

## ✅ Lo que ya Está Implementado

1. **Método `updateLastInteraction()`** en CashService
2. **Método `updateLastInteraction()`** en AppDatabase
3. **Actualización en HomePage.initState()**
4. **Actualización en HomePage._saveOrder()**
5. **Actualización en app_page al reanudar sesión**
6. **Nueva lógica de validación en `validateCashSessionState()`**

---

## 📝 Pasos para Completar la Implementación

### Paso 1: MyProductsPage
```dart
// En lib/features/my_products/presentation/my_products_page.dart

void initState() {
  super.initState();
  // ... código existente ...
  
  // Agregar esta línea:
  CashService.updateLastInteraction(widget.database);
}
```

### Paso 2: SalesHistoryPage
```dart
// En lib/features/sales_history/presentation/sales_history_page.dart

void initState() {
  super.initState();
  // ... código existente ...
  
  // Agregar esta línea:
  CashService.updateLastInteraction(widget.database);
}
```

### Paso 3: Probar
```dart
// En app_page.dart, verifica que el diálogo nuevo se muestre:
// 1. Abre la app
// 2. Espera 30+ minutos sin interacción
// 3. Vuelve a abrir la app
// 4. Debe mostrar el diálogo con el tipo de sesión correcta
```

---

## 🐛 Debugging

### Ver si se está actualizando lastInteraction:
```dart
// En CashService.updateLastInteraction()
print('[CashService] Actualizando lastInteraction para sesión $cashSessionId');

// En database.dart updateLastInteraction()
print('[Database] Updated lastInteraction to ${DateTime.now()}');
```

### Ver estado de sesión:
```dart
final session = await database.getCashSessionOpened();
print('Session state: ${session?.type}, lastInteraction: ${session?.lastInteraction}');
```

---

## 📊 Resumen de Cambios

| Archivo | Cambio | Línea |
|---------|--------|-------|
| database.dart | Agregados 4 métodos nuevos | ~412-460 |
| cash_service.dart | Corregido cálculo de cierre | ~42-47 |
| cash_service.dart | Agregados 3 métodos nuevos | ~60-165 |
| cash_service.dart | Agregada clase CashSessionValidation | ~176-186 |
| home_page.dart | Actualización al registrar venta | ~1142 |
| home_page.dart | Actualización en initState | ~93 |
| app_page.dart | Nueva lógica de validación | ~64-89 |
| app_page.dart | Nuevo diálogo de sesión pendiente | ~92-162 |

