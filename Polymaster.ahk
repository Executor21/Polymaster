/*
Script: Polymaster
Συγγραφέας: Tasos
Έτος: 2025
MIT License
Copyright (c) 2025 Tasos
*/
#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn All, Off

; Μοντέρνο GUI με βελτιωμένη εμφάνιση
TraySetIcon("Shell32.dll", 44)
MyGui := Gui("-Resize +MaximizeBox +MinimizeBox", "Polymaster - Διαχείριση Κοινόχρηστων")
MyGui.OnEvent("Close", GuiClose)
MyGui.OnEvent("Escape", GuiClose)
MyGui.SetFont("s10", "Segoe UI")
MyGui.BackColor := "0xF0F0F0"
; Status Bar
StatusBar := MyGui.AddStatusBar(, "Έτοιμο | Έκδοση: v1.0")

; Tab Control
TabCtrl := MyGui.Add("Tab3", "x10 y10 w1310 h720", 
    ["Διαχείριση Εξόδων", "Εισαγωγή/Επεξεργασία", 
     "Λίστα Διαμερισμάτων", "Υπολογισμός Οφειλών", 
     "Ταμείο Πολυκατοικίας", "Αναφορές"])

; ============================================
; Tab 1: Διαχείριση Εξόδων
; ============================================
TabCtrl.UseTab(1)

MyGui.Add("GroupBox", "x25 y50 w620 h130", "📅 ΔΙΑΧΕΙΡΙΣΗ ΠΕΡΙΟΔΩΝ")
MyGui.Add("Text", "x45 y75 w100", "Τρέχουσα Περίοδος:")
EditPeriod := MyGui.Add("Edit", "x160 y72 w350 h25", "Δεκέμβρης 2025")
BtnNewPeriod := MyGui.Add("Button", "x520 y72 w110 h30", "🆕 Νέα Περίοδος")
BtnNewPeriod.OnEvent("Click", NewPeriod)
BtnNewPeriod.SetFont("s9 Bold")
BtnLoadPeriod := MyGui.Add("Button", "x45 y115 w130 h35", "📂 Φόρτωση Περιόδου")
BtnLoadPeriod.OnEvent("Click", (*) => LoadPeriod())
BtnLoadPeriod.SetFont("s9 Bold")
BtnAddExpense := MyGui.Add("Button", "x185 y115 w130 h35", "➕ Προσθήκη Εξόδων")
BtnAddExpense.OnEvent("Click", ShowExpenseWindow)
BtnAddExpense.SetFont("s9 Bold")

; Σύνολα Εξόδων
MyGui.Add("GroupBox", "x25 y190 w620 h180", "💰 ΣΥΝΟΛΑ ΕΞΟΔΩΝ ΠΕΡΙΟΔΟΥ")
MyGui.Add("Text", "x45 y220 w180 h25 Background0xE8F5E9", "📊 Κοινόχρηστα:")
TotalCommonExpenses := MyGui.Add("Edit", "x230 y220 w100 h25 ReadOnly Background0xE8F5E9 Center", "0.00 €")
TotalCommonExpenses.SetFont("s10 Bold c0x1B5E20")

MyGui.Add("Text", "x45 y255 w180 h25 Background0xE3F2FD", "🛗 Ασανσέρ:")
TotalElevatorExpenses := MyGui.Add("Edit", "x230 y255 w100 h25 ReadOnly Background0xE3F2FD Center", "0.00 €")
TotalElevatorExpenses.SetFont("s10 Bold c0x0D47A1")

MyGui.Add("Text", "x45 y290 w180 h25 Background0xFFF3E0", "🔥 Θέρμανση:")
TotalHeatingExpenses := MyGui.Add("Edit", "x230 y290 w100 h25 ReadOnly Background0xFFF3E0 Center", "0.00 €")
TotalHeatingExpenses.SetFont("s10 Bold c0xE65100")

MyGui.Add("Text", "x45 y325 w180 h25 Background0xF3E5F5", "🖨️ Έκδοση:")
TotalPrintingExpenses := MyGui.Add("Edit", "x230 y325 w100 h25 ReadOnly Background0xF3E5F5 Center", "0.00 €")
TotalPrintingExpenses.SetFont("s10 Bold c0x6A1B9A")

MyGui.Add("Text", "x360 y220 w160 h25 Background0xFFF9C4", "💰 Αποθεματικό:")
TotalReserveExpenses := MyGui.Add("Edit", "x525 y220 w100 h25 ReadOnly Background0xFFF9C4 Center", "0.00 €")
TotalReserveExpenses.SetFont("s10 Bold c0xF57F17")

MyGui.Add("Text", "x360 y255 w160 h30 Background0xFFEBEE", "💵 ΓΕΝΙΚΟ ΣΥΝΟΛΟ:")
TotalAllExpenses := MyGui.Add("Edit", "x525 y255 w100 h30 ReadOnly Background0xFFCDD2 Center", "0.00 €")
TotalAllExpenses.SetFont("s11 Bold c0xC62828")

; Ιστορικό Εξόδων
MyGui.Add("GroupBox", "x25 y380 w620 h320", "📊 ΙΣΤΟΡΙΚΟ ΕΞΟΔΩΝ ΠΕΡΙΟΔΟΥ")
LVExpenses := MyGui.Add("ListView", "x45 y410 w580 h240 Background0xFFFFFF Grid", ["Ημερομηνία", "Ποσό", "Κατηγορία", "Είδος", "Περιγραφή"])
LVExpenses.ModifyCol(1, 95)
LVExpenses.ModifyCol(2, 85)
LVExpenses.ModifyCol(3, 115)
LVExpenses.ModifyCol(4, 115)
LVExpenses.ModifyCol(5, 150)

LVExpenses.OnEvent("DoubleClick", LVExpenses_DoubleClick)
MyGui.SetFont("s9 Bold")
BtnEditExpense := MyGui.Add("Button", "x45 y660 w140 h30", "✏️ Επεξεργασία")
BtnEditExpense.OnEvent("Click", EditExpense)
BtnDeleteExpense := MyGui.Add("Button", "x195 y660 w140 h30", "🗑️ Διαγραφή")
BtnDeleteExpense.OnEvent("Click", DeleteExpense)
MyGui.SetFont("s10 Norm")

; Δεξιά στήλη - Πληροφορίες
MyGui.Add("GroupBox", "x660 y50 w630 h650", "ℹ️ ΠΛΗΡΟΦΟΡΙΕΣ & ΟΔΗΓΙΕΣ ΧΡΗΣΗΣ")
InfoText := MyGui.Add("Edit", "x680 y80 w590 h600 ReadOnly -Wrap +VScroll Background0xFFFFF0", "
(
════════════════════════════════════════════════
  ΔΙΑΧΕΙΡΙΣΗ ΕΞΟΔΩΝ - ΟΔΗΓΙΕΣ
════════════════════════════════════════════════

📋 ΒΑΣΙΚΗ ΛΕΙΤΟΥΡΓΙΑ:

Αυτή η καρτέλα εμφανίζει τα έξοδα της τρέχουσας
περιόδου και τα συνολικά ποσά ανά κατηγορία.


🆕 ΔΗΜΙΟΥΡΓΙΑ ΝΕΑΣ ΠΕΡΙΟΔΟΥ:

1. Συμπληρώστε όνομα (π.χ. 'Ιανουάριος 2025')
2. Πατήστε 'Νέα Περίοδος'
3. Τα ανεξόφλητα χρέη μεταφέρονται αυτόματα
4. Δημιουργείται νέος φάκελος με το όνομα


📥 ΦΟΡΤΩΣΗ ΠΕΡΙΟΔΟΥ:

- Επιλέξτε αρχείο .ini από προηγούμενη περίοδο
- Φορτώνονται: Διαμερίσματα, Έξοδα, Πληρωμές
- Εμφανίζεται λεπτομερής αναφορά φόρτωσης


➕ ΠΡΟΣΘΗΚΗ ΕΞΟΔΟΥ:

1. Πατήστε 'Προσθήκη Εξόδων'
2. Επιλέξτε Κατηγορία (αυτόματη επιλογή πρώτης)
3. Επιλέξτε Είδος (αυτόματη επιλογή πρώτου)
4. Συμπληρώστε Ημερομηνία & Ποσό
5. Πατήστε 'Αποθήκευση'

✓ Το έξοδο προστίθεται ΑΜΕΣΑ στο ιστορικό
✓ Αφαιρείται αυτόματα από το ταμείο
✓ Οι οφειλές επαναυπολογίζονται αυτόματα


✏️ ΕΠΕΞΕΡΓΑΣΙΑ/ΔΙΑΓΡΑΦΗ:

- Διπλό κλικ σε έξοδο → Επεξεργασία
- Επιλογή + 'Διαγραφή' → Μόνιμη διαγραφή

ΠΡΟΣΟΧΗ: Διαγραφή εξόδου:
- Επιστρέφει το ποσό στο ταμείο
- Επαναυπολογίζει όλες τις οφειλές


📊 ΚΑΤΗΓΟΡΙΕΣ ΕΞΟΔΩΝ:

ΚΟΙΝΟΧΡΗΣΤΑ: Καθαριότητα, Ρεύμα, Νερό
ΑΣΑΝΣΕΡ: Συντήρηση, Επισκευές
ΘΕΡΜΑΝΣΗ: Καύσιμα, Συντήρηση λεβήτα
ΕΚΔΟΣΗ: Κόστος εκτύπωσης
ΑΠΟΘΕΜΑΤΙΚΟ: Για μελλοντικές επισκευές


💾 ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ:

✓ Κάθε πράξη αποθηκεύεται ΑΜΕΣΑ
✓ Δεν χρειάζεται 'Save' button
✓ Μπορείτε να κλείσετε οποτεδήποτε


📂 ΑΡΧΕΙΑ:

Κάθε περίοδος δημιουργεί:
- [Όνομα].ini → Κύρια δεδομένα
- [Όνομα]_Transactions.ini → Συναλλαγές
)")
InfoText.SetFont("s9", "Consolas")

; ============================================
; Tab 2: Εισαγωγή/Επεξεργασία
; ============================================
TabCtrl.UseTab(2)

MyGui.Add("GroupBox", "x25 y50 w500 h500", "🏢 ΣΤΟΙΧΕΙΑ ΔΙΑΜΕΡΙΣΜΑΤΟΣ")

MyGui.Add("Text", "x45 y80 w160", "Διαμέρισμα:")
EditApartment := MyGui.Add("Edit", "x220 y77 w280 h25")

MyGui.Add("Text", "x45 y120 w160", "Όνομα Ιδιοκτήτη:")
EditOwner := MyGui.Add("Edit", "x220 y117 w280 h25")

MyGui.Add("Text", "x45 y160 w160", "Τηλέφωνο:")
EditPhone := MyGui.Add("Edit", "x220 y157 w280 h25")

MyGui.Add("Text", "x45 y200 w160", "Χιλιοστά Κοινοχρήστων:")
EditCommon := MyGui.Add("Edit", "x220 y197 w280 h25")

MyGui.Add("Text", "x45 y240 w160", "Χιλιοστά Ασανσέρ:")
EditElevator := MyGui.Add("Edit", "x220 y237 w280 h25")

MyGui.Add("Text", "x45 y280 w160", "Χιλιοστά Θέρμανσης:")
EditHeating := MyGui.Add("Edit", "x220 y277 w280 h25")

MyGui.Add("Text", "x45 y320 w160", "Ποσοστό Έκδοσης (%):")
EditPercentage := MyGui.Add("Edit", "x220 y317 w280 h25")
EditPercentage.Enabled := false

CheckHeating := MyGui.Add("CheckBox", "x45 y360 w400", "Συμμετέχει στην Κεντρική Θέρμανση")
CheckHeating.Value := 1

BtnAdd := MyGui.Add("Button", "x45 y410 w110 h40", "➕ &Προσθήκη")
BtnAdd.OnEvent("Click", AddApartment)
BtnAdd.SetFont("s10 Bold")

BtnUpdate := MyGui.Add("Button", "x165 y410 w110 h40", "✅ &Ενημέρωση")
BtnUpdate.OnEvent("Click", UpdateApartment)
BtnUpdate.Enabled := false
BtnUpdate.SetFont("s10 Bold")

BtnDelete := MyGui.Add("Button", "x285 y410 w110 h40", "🗑️ &Διαγραφή")
BtnDelete.OnEvent("Click", DeleteApartment)
BtnDelete.Enabled := false
BtnDelete.SetFont("s10 Bold")

BtnClear := MyGui.Add("Button", "x45 y460 w350 h35", "🔄 &Καθαρισμός Πεδίων")
BtnClear.OnEvent("Click", ClearFields)
BtnClear.SetFont("s9 Bold")

BtnAutoPercentage := MyGui.Add("Button", "x45 y505 w350 h35", "🧮 Αυτόματος Υπολογισμός Ποσοστών")
BtnAutoPercentage.OnEvent("Click", CalculatePercentages)
BtnAutoPercentage.SetFont("s9 Bold")

MyGui.Add("GroupBox", "x25 y560 w500 h140", "📊 ΕΛΕΓΧΟΣ ΣΥΝΟΛΩΝ")
MyGui.Add("Text", "x45 y580 w200 h25 +0x200", "Σύνολο Κοινοχρήστων:")
TotalCommonText := MyGui.Add("Text", "x250 y580 w120 h25 +0x200", "0")
TotalCommonText.SetFont("s10 Bold")

MyGui.Add("Text", "x45 y610 w200 h25 +0x200", "Σύνολο Ασανσέρ:")
TotalElevatorText := MyGui.Add("Text", "x250 y610 w120 h25 +0x200", "0")
TotalElevatorText.SetFont("s10 Bold")

MyGui.Add("Text", "x45 y640 w200 h25 +0x200", "Σύνολο Θέρμανσης:")
TotalHeatingText := MyGui.Add("Text", "x250 y640 w120 h25 +0x200", "0")
TotalHeatingText.SetFont("s10 Bold")

MyGui.Add("Text", "x45 y670 w200 h25 +0x200", "Σύνολο Ποσοστών (%):")
TotalPercentageText := MyGui.Add("Text", "x250 y670 w120 h25 +0x200", "0")
TotalPercentageText.SetFont("s10 Bold")

MyGui.Add("GroupBox", "x540 y50 w750 h650", "ℹ️ ΟΔΗΓΙΕΣ & ΠΛΗΡΟΦΟΡΙΕΣ")
GuideText := MyGui.Add("Edit", "x560 y80 w710 h600 ReadOnly -Wrap +VScroll Background0xFFFFF0", "
(
════════════════════════════════════════════════════════════
  ΔΙΑΜΕΡΙΣΜΑΤΑ - ΟΔΗΓΙΕΣ ΕΙΣΑΓΩΓΗΣ/ΕΠΕΞΕΡΓΑΣΙΑΣ
════════════════════════════════════════════════════════════

📝 ΠΡΟΣΘΗΚΗ ΝΕΟΥ ΔΙΑΜΕΡΙΣΜΑΤΟΣ:

1. Συμπληρώστε όλα τα πεδία:
   • Διαμέρισμα (π.χ. 'Α1', '1ος Όροφος')
   • Ονοματεπώνυμο ιδιοκτήτη
   • Τηλέφωνο επικοινωνίας
   • Χιλιοστά Κοινοχρήστων (0-1000)
   • Χιλιοστά Ασανσέρ (0-1000)
   • Χιλιοστά Θέρμανσης (0-1000)

2. Επιλέξτε αν συμμετέχει στην κεντρική θέρμανση

3. Πατήστε 'Προσθήκη'

✓ Αποθηκεύεται αυτόματα
✓ Τα ποσοστά έκδοσης υπολογίζονται αυτόματα


✏️ ΕΠΕΞΕΡΓΑΣΙΑ ΔΙΑΜΕΡΙΣΜΑΤΟΣ:

1. Πηγαίνετε στο Tab 'Λίστα Διαμερισμάτων'
2. Διπλό κλικ στο διαμέρισμα που θέλετε
3. Επιστροφή στο Tab 2 με φορτωμένα στοιχεία
4. Κάντε τις αλλαγές
5. Πατήστε 'Ενημέρωση'


🗑️ ΔΙΑΓΡΑΦΗ:

1. Φορτώστε διαμέρισμα (διπλό κλικ από λίστα)
2. Πατήστε 'Διαγραφή'
3. Επιβεβαιώστε

ΠΡΟΣΟΧΗ: Η διαγραφή είναι ΜΟΝΙΜΗ!


🔢 ΧΙΛΙΟΣΤΑ - ΣΩΣΤΕΣ ΤΙΜΕΣ:

Ελέγχετε τα σύνολα στο κάτω μέρος:

✓ ΣΩΣΤΟ: Κοινόχρηστα = 1000
✓ ΣΩΣΤΟ: Ασανσέρ = 1000
✓ ΣΩΣΤΟ: Θέρμανση = 1000 (μόνο όσοι έχουν θέρμανση)
✓ ΣΩΣΤΟ: Ποσοστά = 100%

✗ ΛΑΘΟΣ: Οποιοδήποτε άλλο σύνολο

Αν τα σύνολα είναι λάθος:
→ Διορθώστε τα χιλιοστά των διαμερισμάτων
→ Μην προχωρήσετε σε υπολογισμούς οφειλών


📊 ΠΟΣΟΣΤΑ ΕΚΔΟΣΗΣ:

- Υπολογίζονται ΑΥΤΟΜΑΤΑ με το κουμπί
  'Αυτόματος Υπολογισμός Ποσοστών Έκδοσης'

- Μοιράζονται ΙΣΟΠΟΣΑ σε όλα τα διαμερίσματα

- Παράδειγμα: 18 διαμερίσματα
  → 100% / 18 = 5.56% το καθένα

- Το πεδίο 'Ποσοστό Έκδοσης' είναι ΜΟΝΟ για ανάγνωση


☑️ ΚΕΝΤΡΙΚΗ ΘΕΡΜΑΝΣΗ:

- Αν διαμέρισμα ΔΕΝ έχει κεντρική θέρμανση:
  → Αποεπιλέξτε το checkbox
  → Θα έχει 0 χιλιοστά θέρμανσης

- Αν το επιλέξετε αργότερα:
  → Θα πρέπει να ορίσετε χιλιοστά θέρμανσης


💾 ΑΠΟΘΗΚΕΥΣΗ:

✓ Κάθε αλλαγή αποθηκεύεται ΑΜΕΣΑ
✓ Δεν χρειάζεται χειροκίνητη αποθήκευση
)")
GuideText.SetFont("s9", "Consolas")

; ============================================
; Tab 3: Λίστα Διαμερισμάτων
; ============================================
TabCtrl.UseTab(3)

MyGui.Add("GroupBox", "x25 y50 w1260 h470", "📋 ΛΙΣΤΑ ΔΙΑΜΕΡΙΣΜΑΤΩΝ")
LV := MyGui.Add("ListView", "x45 y80 w1220 h420 Background0xFFFFFF Grid", [
    "Διαμέρισμα", "Ιδιοκτήτης", "Τηλέφωνο", 
    "Κοινοχρήστων", "Ασανσέρ", "Θέρμανσης", 
    "Ποσοστό %", "Συμμετοχή Θέρμανσης"
])
LV.ModifyCol(1, 140)
LV.ModifyCol(2, 200)
LV.ModifyCol(3, 130)
LV.ModifyCol(4, 110)
LV.ModifyCol(5, 110)
LV.ModifyCol(6, 110)
LV.ModifyCol(7, 100)
LV.ModifyCol(8, 150)

MyGui.Add("GroupBox", "x25 y530 w1260 h65", "⚙️ ΤΑΞΙΝΟΜΗΣΗ & ΔΙΑΧΕΙΡΙΣΗ")
MyGui.SetFont("s9 Bold")
MyGui.Add("Button", "x45 y555 w155 h35", "🏠 Ταξιν: Διαμέρισμα").OnEvent("Click", (*) => SortLV(1))
MyGui.Add("Button", "x210 y555 w155 h35", "👤 Ταξιν: Ιδιοκτήτης").OnEvent("Click", (*) => SortLV(2))
MyGui.Add("Button", "x375 y555 w155 h35", "📊 Ταξιν: Κοινόχρηστα").OnEvent("Click", (*) => SortLV(4))

BtnSaveINI := MyGui.Add("Button", "x640 y555 w155 h35", "💾 &Αποθήκευση INI")
BtnSaveINI.OnEvent("Click", SaveToINI)
BtnSaveINI.SetFont("s10 Bold")

BtnLoadINI := MyGui.Add("Button", "x805 y555 w155 h35", "📂 &Φόρτωση INI")
BtnLoadINI.OnEvent("Click", LoadFromINI)
BtnLoadINI.SetFont("s10 Bold")

BtnAutoPercentage2 := MyGui.Add("Button", "x970 y555 w290 h35", "🧮 Αυτόματος Υπολογισμός Ποσοστών")
BtnAutoPercentage2.OnEvent("Click", CalculatePercentages)
BtnAutoPercentage2.SetFont("s9 Bold")
MyGui.SetFont("s10 Norm")

MyGui.Add("GroupBox", "x25 y605 w1260 h95", "✅ ΕΛΕΓΧΟΣ ΣΥΝΟΛΩΝ - Κοινόχρηστα=1000, Ασανσέρ=1000, Θέρμανση=1000, Ποσοστά=100%")
MyGui.Add("Text", "x45 y640 w150 h25 +0x200", "Σύνολο Κοινοχρήστων:")
LVTotalCommon := MyGui.Add("Text", "x200 y640 w90 h25 +0x200", "0")
LVTotalCommon.SetFont("s10 Bold")

MyGui.Add("Text", "x310 y640 w150 h25 +0x200", "Σύνολο Ασανσέρ:")
LVTotalElevator := MyGui.Add("Text", "x465 y640 w90 h25 +0x200", "0")
LVTotalElevator.SetFont("s10 Bold")

MyGui.Add("Text", "x575 y640 w150 h25 +0x200", "Σύνολο Θέρμανσης:")
LVTotalHeating := MyGui.Add("Text", "x730 y640 w90 h25 +0x200", "0")
LVTotalHeating.SetFont("s10 Bold")

MyGui.Add("Text", "x840 y640 w150 h25 +0x200", "Σύνολο Ποσοστών:")
LVTotalPercentage := MyGui.Add("Text", "x995 y640 w90 h25 +0x200", "0 %")
LVTotalPercentage.SetFont("s10 Bold")

MyGui.Add("Text", "x45 y670 w1220 h20 Center", "⚠️ Αν τα σύνολα δεν είναι σωστά, διορθώστε τα χιλιοστά στην καρτέλα 'Εισαγωγή/Επεξεργασία'")

; ============================================
; Tab 4: Υπολογισμός Οφειλών
; ============================================
TabCtrl.UseTab(4)

MyGui.Add("GroupBox", "x25 y50 w1260 h130", "💰 ΣΥΝΟΛΙΚΑ ΕΞΟΔΑ ΠΕΡΙΟΔΟΥ (Αυτόματη Ενημέρωση)")

MyGui.Add("Text", "x45 y80 w160 h25 +0x200", "Κοινόχρηστα:")
TotalCommonCostText := MyGui.Add("Text", "x210 y80 w120 h25 +0x200", "0.00 €")
TotalCommonCostText.SetFont("s10 Bold")

MyGui.Add("Text", "x345 y80 w160 h25 +0x200", "Ασανσέρ:")
TotalElevatorCostText := MyGui.Add("Text", "x510 y80 w120 h25 +0x200", "0.00 €")
TotalElevatorCostText.SetFont("s10 Bold")

MyGui.Add("Text", "x645 y80 w160 h25 +0x200", "Έκδοση:")
TotalPrintingCostText := MyGui.Add("Text", "x810 y80 w120 h25 +0x200", "0.00 €")
TotalPrintingCostText.SetFont("s10 Bold")

MyGui.Add("Text", "x945 y80 w160 h25 +0x200", "Θέρμανση:")
TotalHeatingCostText := MyGui.Add("Text", "x1110 y80 w120 h25 +0x200", "0.00 €")
TotalHeatingCostText.SetFont("s10 Bold")

MyGui.Add("Text", "x45 y115 w160 h25 +0x200", "Αποθεματικό:")
TotalReserveCostText := MyGui.Add("Text", "x210 y115 w120 h25 +0x200", "0.00 €")
TotalReserveCostText.SetFont("s10 Bold")

MyGui.Add("Text", "x345 y115 w160 h25 +0x200", "ΓΕΝΙΚΟ ΣΥΝΟΛΟ:")
TotalAllCostsText := MyGui.Add("Text", "x510 y115 w150 h25 +0x200", "0.00 €")
TotalAllCostsText.SetFont("s11 Bold", "0000CC")

MyGui.Add("GroupBox", "x25 y190 w1260 h430", "📊 ΑΝΑΛΥΤΙΚΕΣ ΟΦΕΙΛΕΣ - ΜΟΝΟ Διαμερίσματα που Χρωστούν")
LVDebts := MyGui.Add("ListView", "x45 y220 w1220 h380 Background0xFFFFFF Grid", [
    "Διαμέρισμα", "Ιδιοκτήτης", 
    "Κοινόχρηστα", "Ασανσέρ", "Έκδοση", "Θέρμανση", "Αποθεματικό",
    "Οφειλή Περιόδου", "Χρέος Προηγ.", "Σύνολο Οφειλής"
])
LVDebts.ModifyCol(1, 110)
LVDebts.ModifyCol(2, 160)
LVDebts.ModifyCol(3, 95)
LVDebts.ModifyCol(4, 95)
LVDebts.ModifyCol(5, 95)
LVDebts.ModifyCol(6, 95)
LVDebts.ModifyCol(7, 95)
LVDebts.ModifyCol(8, 110)
LVDebts.ModifyCol(9, 110)
LVDebts.ModifyCol(10, 120)

MyGui.Add("GroupBox", "x25 y630 w1260 h70", "💳 ΣΥΝΟΛΙΚΕΣ ΟΦΕΙΛΕΣ ΟΛΩΝ ΤΩΝ ΔΙΑΜΕΡΙΣΜΑΤΩΝ")
MyGui.Add("Text", "x45 y660 w140 h25 +0x200", "Κοινόχρηστα:")
TotalDebtCommonText := MyGui.Add("Text", "x185 y660 w90 h25 +0x200", "0.00 €")
TotalDebtCommonText.SetFont("s9 Bold")

MyGui.Add("Text", "x290 y660 w140 h25 +0x200", "Ασανσέρ:")
TotalDebtElevatorText := MyGui.Add("Text", "x430 y660 w90 h25 +0x200", "0.00 €")
TotalDebtElevatorText.SetFont("s9 Bold")

MyGui.Add("Text", "x535 y660 w140 h25 +0x200", "Έκδοση:")
TotalDebtPrintingText := MyGui.Add("Text", "x675 y660 w90 h25 +0x200", "0.00 €")
TotalDebtPrintingText.SetFont("s9 Bold")

MyGui.Add("Text", "x780 y660 w140 h25 +0x200", "Θέρμανση:")
TotalDebtHeatingText := MyGui.Add("Text", "x920 y660 w90 h25 +0x200", "0.00 €")
TotalDebtHeatingText.SetFont("s9 Bold")

MyGui.Add("Text", "x1025 y660 w140 h25 +0x200", "ΓΕΝΙΚΟ ΣΥΝΟΛΟ:")
TotalAllDebtsText := MyGui.Add("Text", "x1165 y660 w110 h25 +0x200", "0.00 €")
TotalAllDebtsText.SetFont("s10 Bold", "CC0000")

; ============================================
; Tab 5: Ταμείο Πολυκατοικίας
; ============================================
TabCtrl.UseTab(5)

MyGui.Add("GroupBox", "x25 y50 w640 h150", "💵 ΤΡΕΧΟΥΣΑ ΚΑΤΑΣΤΑΣΗ ΤΑΜΕΙΟΥ")
MyGui.Add("Text", "x45 y80 w180 h25 Background0xE8F5E9", "💵 Μετρητά:")
CurrentBalanceText := MyGui.Add("Edit", "x230 y80 w150 h25 ReadOnly Background0xC8E6C9 Center", "0.00 €")
CurrentBalanceText.SetFont("s11 Bold c0x1B5E20")

MyGui.Add("Text", "x45 y115 w180 h25 Background0xFFEBEE", "📊 Χρωστούμενα:")
PreviousDebtText := MyGui.Add("Edit", "x230 y115 w150 h25 ReadOnly Background0xFFCDD2 Center", "0.00 €")
PreviousDebtText.SetFont("s10 Bold c0xC62828")

MyGui.Add("Text", "x420 y80 w100 h25 Background0xE3F2FD", "💰 Εισπράξεις:")
TotalIncomeText := MyGui.Add("Edit", "x520 y80 w115 h25 ReadOnly Background0xE3F2FD Center", "0.00 €")
TotalIncomeText.SetFont("s10 Bold c0x0D47A1")

MyGui.Add("Text", "x420 y115 w100 h25 Background0xFFF3E0", "📉 Έξοδα:")
TotalExpensesText := MyGui.Add("Edit", "x520 y115 w115 h25 ReadOnly Background0xFFF3E0 Center", "0.00 €")
TotalExpensesText.SetFont("s10 Bold c0xE65100")

MyGui.Add("Text", "x45 y150 w180 h25 Background0xE1F5FE", "💎 Διαθέσιμο (Εισ.-Εξ.):")
NetBalanceText := MyGui.Add("Edit", "x230 y150 w150 h25 ReadOnly Background0xB3E5FC Center", "0.00 €")
NetBalanceText.SetFont("s11 Bold c0x01579B")

MyGui.Add("GroupBox", "x25 y210 w640 h70", "⚡ ΕΝΕΡΓΕΙΕΣ ΤΑΜΕΙΟΥ")
MyGui.SetFont("s9 Bold")
BtnInitialBalance := MyGui.Add("Button", "x45 y235 w180 h35", "💰 Αρχικό Υπόλοιπο")
BtnInitialBalance.OnEvent("Click", SetInitialBalance)

BtnAddManualDebt := MyGui.Add("Button", "x240 y235 w180 h35", "➕ Προσθήκη Χρέους")
BtnAddManualDebt.OnEvent("Click", AddManualDebt)

BtnSaveTreasury := MyGui.Add("Button", "x435 y235 w220 h35", "💾 Αποθήκευση Ταμείου")
BtnSaveTreasury.OnEvent("Click", SaveTreasuryData)
MyGui.SetFont("s10 Norm")

MyGui.Add("GroupBox", "x25 y290 w640 h410", "📋 ΙΣΤΟΡΙΚΟ ΣΥΝΑΛΛΑΓΩΝ ΠΕΡΙΟΔΟΥ")
LVTransactions := MyGui.Add("ListView", "x45 y320 w600 h330 Background0xFFFFFF Grid", ["Ημερομηνία", "Ποσό", "Τύπος", "Περιγραφή", "Διαμέρισμα"])
LVTransactions.ModifyCol(1, 100)
LVTransactions.ModifyCol(2, 90)
LVTransactions.ModifyCol(3, 100)
LVTransactions.ModifyCol(4, 200)
LVTransactions.ModifyCol(5, 100)
MyGui.SetFont("s9 Bold")
BtnEditTransaction := MyGui.Add("Button", "x45 y660 w140 h30", "✏️ Επεξεργασία")
BtnEditTransaction.OnEvent("Click", EditTransaction)
BtnDeleteTransaction := MyGui.Add("Button", "x195 y660 w140 h30", "🗑️ Διαγραφή")
BtnDeleteTransaction.OnEvent("Click", DeleteTransaction)
MyGui.SetFont("s10 Norm")
LVTransactions.OnEvent("DoubleClick", LVTransactions_DoubleClick)

MyGui.Add("GroupBox", "x680 y50 w605 h420", "💳 ΑΝΕΞΟΦΛΗΤΑ ΧΡΕΗ - ΜΟΝΟ όσοι Χρωστούν")
LVApartmentDebts := MyGui.Add("ListView", "x700 y80 w565 h360 Background0xFFFFFF Grid", ["Διαμέρισμα", "Ιδιοκτήτης", "Χρέος Περιόδου", "Χρέος Προηγ.", "Σύνολο"])
LVApartmentDebts.ModifyCol(1, 120)
LVApartmentDebts.ModifyCol(2, 150)
LVApartmentDebts.ModifyCol(3, 95)
LVApartmentDebts.ModifyCol(4, 95)
LVApartmentDebts.ModifyCol(5, 95)
LVApartmentDebts.OnEvent("DoubleClick", LVApartmentDebts_DoubleClick)



MyGui.Add("GroupBox", "x680 y480 w605 h220", "ℹ️ ΠΛΗΡΟΦΟΡΙΕΣ ΛΕΙΤΟΥΡΓΙΑΣ")
MyGui.Add("Text", "x700 y505 w565 h105", "
(
ΟΔΗΓΙΕΣ:
- Διπλό κλικ σε διαμέρισμα → Γρήγορη πληρωμή
- Τα διαμερίσματα που ξεχρεώνουν εξαφανίζονται αυτόματα
- Μετρητά: Πραγματικό υπόλοιπο ταμείου
- Χρωστούμενα: Υπολογισμός από τις οφειλές όλων
- Διαθέσιμο: Μετρητά + Χρωστούμενα
)")

; ============================================
; Tab 6: Αναφορές
; ============================================
TabCtrl.UseTab(6)

MyGui.Add("GroupBox", "x25 y50 w1260 h280", "📄 ΕΠΙΛΟΓΕΣ ΑΝΑΦΟΡΩΝ")

MyGui.Add("Text", "x45 y80 w150", "Τύπος Αναφοράς:")

MyGui.Add("GroupBox", "x45 y110 w580 h200", "📊 ΓΕΝΙΚΕΣ ΑΝΑΦΟΡΕΣ")
MyGui.SetFont("s10 Bold")
BtnReportAll := MyGui.Add("Button", "x65 y140 w250 h40", "📄 Πίνακας Όλων Διαμερισμάτων")
BtnReportAll.OnEvent("Click", GenerateAllApartmentsReport)

BtnReportExpenses := MyGui.Add("Button", "x65 y190 w250 h40", "📊 Ιστορικό Εξόδων Περιόδου")
BtnReportExpenses.OnEvent("Click", GenerateExpensesReport)

BtnReportTransactions := MyGui.Add("Button", "x65 y240 w250 h40", "💰 Ιστορικό Συναλλαγών")
BtnReportTransactions.OnEvent("Click", GenerateTransactionsReport)
MyGui.SetFont("s10 Norm")

MyGui.Add("GroupBox", "x645 y110 w600 h200", "🏢 ΑΝΑΛΥΤΙΚΕΣ ΑΝΑΦΟΡΕΣ ΑΝΑ ΔΙΑΜΕΡΙΣΜΑ")
MyGui.Add("Text", "x665 y145 w150", "Επιλέξτε Διαμέρισμα:")
DDApartmentReport := MyGui.Add("DropDownList", "x825 y142 w200")

MyGui.SetFont("s10 Bold")
BtnReportSingle := MyGui.Add("Button", "x665 y185 w250 h40", "📋 Αναλυτική Διαμερίσματος")
BtnReportSingle.OnEvent("Click", GenerateSingleApartmentReport)

BtnReportAllDetailed := MyGui.Add("Button", "x665 y235 w250 h40", "📑 Αναλυτικές ΟΛΩΝ")
BtnReportAllDetailed.OnEvent("Click", GenerateAllDetailedReports)
MyGui.SetFont("s10 Norm")

MyGui.Add("GroupBox", "x25 y340 w1260 h100", "⚙️ ΡΥΘΜΙΣΕΙΣ")
MyGui.Add("Text", "x45 y370 w200", "Φάκελος Αποθήκευσης:")
EditReportsFolder := MyGui.Add("Edit", "x250 y367 w800 h25 ReadOnly", A_ScriptDir "\Αναφορές")
MyGui.SetFont("s9 Bold")
BtnBrowseFolder := MyGui.Add("Button", "x1060 y367 w190 h30", "📁 Επιλογή Φακέλου...")
BtnBrowseFolder.OnEvent("Click", SelectReportsFolder)
MyGui.SetFont("s10 Norm")

MyGui.Add("GroupBox", "x25 y450 w1260 h250", "ℹ️ ΠΛΗΡΟΦΟΡΙΕΣ ΑΝΑΦΟΡΩΝ")
MyGui.Add("Edit", "x45 y480 w1220 h200 ReadOnly -Wrap +VScroll Background0xFFFFF0", "
(
═══════════════════════════════════════════════════════════
  ΑΝΑΦΟΡΕΣ - ΟΔΗΓΙΕΣ ΧΡΗΣΗΣ
═══════════════════════════════════════════════════════════

📄 ΠΙΝΑΚΑΣ ΟΛΩΝ ΤΩΝ ΔΙΑΜΕΡΙΣΜΑΤΩΝ:
   Δημιουργεί συνολικό πίνακα με:
   • Χιλιοστά και ποσοστά κάθε διαμερίσματος
   • Αναλυτικά έξοδα πολυκατοικίας
   • Οφειλές κάθε διαμερίσματος
   
   Χρήση: Για ανάρτηση στην πολυκατοικία


📋 ΑΝΑΛΥΤΙΚΗ ΔΙΑΜΕΡΙΣΜΑΤΟΣ:
   Εξατομικευμένη αναφορά για ΕΝΑ διαμέρισμα:
   • Αναλυτικός υπολογισμός με τύπους
   • Παράδειγμα: Κοινόχρηστα 250€ × 75/1000 = 18.75€
   
   Βήματα:
   1. Επιλέξτε διαμέρισμα από τη λίστα
   2. Πατήστε 'Αναλυτική Διαμερίσματος'
   
   Χρήση: Για αποστολή στον ιδιοκτήτη


📑 ΑΝΑΛΥΤΙΚΕΣ ΟΛΩΝ:
   Δημιουργεί ξεχωριστό αρχείο για ΚΑΘΕ διαμέρισμα
   • Ένα κλικ → Όλες οι αναφορές μαζί
   • Ιδανικό για μαζική αποστολή email
   
   Χρήση: Όταν θέλετε να στείλετε σε όλους


📊 ΙΣΤΟΡΙΚΟ ΕΞΟΔΩΝ:
   Λίστα με ΟΛΑ τα έξοδα της περιόδου:
   • Ταξινομημένα χρονολογικά
   • Ανά κατηγορία και είδος
   • Συνολικό άθροισμα
   
   Χρήση: Για έλεγχο και λογιστική


💰 ΙΣΤΟΡΙΚΟ ΣΥΝΑΛΛΑΓΩΝ:
   Όλες οι κινήσεις ταμείου:
   • Εισπράξεις (πληρωμές διαμερισμάτων)
   • Έξοδα (αφαιρέσεις από ταμείο)
   • Χειροκίνητα χρέη
   
   Χρήση: Για πλήρη αρχείο κινήσεων


⚙️ ΡΥΘΜΙΣΕΙΣ:

- Όλες οι αναφορές αποθηκεύονται σε ΕΝΑΝ φάκελο
- Προεπιλογή: [Φάκελος Προγράμματος]\Αναφορές
- Μορφή: .txt (ανοίγει με Σημειωματάριο)
- Κωδικοποίηση: UTF-8 (υποστήριξη ελληνικών)
- Μπορείτε να αλλάξετε τον φάκελο με 'Επιλογή Φακέλου...'


📁 ΟΡΓΑΝΩΣΗ:

Ονόματα αρχείων:
- [Περίοδος]_Πίνακας_Διαμερισμάτων.txt
- [Περίοδος]_[Διαμέρισμα]_Αναλυτική.txt
- [Περίοδος]_Ιστορικό_Εξόδων.txt
- [Περίοδος]_Ιστορικό_Συναλλαγών.txt
)")
TabCtrl.UseTab()

; Μεταβλητές
Apartments := Map()
CurrentEditIndex := 0
Expenses := Map()
CurrentPeriod := ""
CurrentPeriodFolder := ""
ExpenseCategories := ["Κοινόχρηστα", "Ασανσέρ", "Θέρμανση", "Έκδοση", "Αποθεματικό"]
ExpenseTypes := Map(
    "Κοινόχρηστα", ["Καθαριότητα", "Ηλ. Ρεύμα", "Νερό", "Πυρασφάλεια", "Κηπουρός", "Άλλα έξοδα"],
    "Ασανσέρ", ["Συντήρηση", "Αντικατάσταση ανταλλακτικών", "Άλλα έξοδα ασανσέρ"],
    "Θέρμανση", ["Λογαριασμοί", "Καύσιμα", "Συντήρηση λεβήτα", "Άλλα έξοδα θέρμανσης"],
    "Έκδοση", ["Εκτύπωση", "Άλλα έξοδα έκδοσης"],
    "Αποθεματικό", ["Αυξηση αποθεματικού"]
)

; Νέες μεταβλητές για το ταμείο
Treasury := Map()
Treasury.Balance := 0
Treasury.TotalIncome := 0
Treasury.TotalExpenses := 0
Treasury.Transactions := Map()
ApartmentDebts := Map()
PreviousPeriodDebts := Map()
ApartmentPayments := Map()

; Events
LV.OnEvent("DoubleClick", LV_DoubleClick)
TabCtrl.OnEvent("Change", TabChanged)
UpdateReportsApartmentList() 

MyGui.Show("w1337 h748")
UpdateTotals()
UpdateTreasuryDisplay()
StatusBar.SetText("✅ Το πρόγραμμα είναι έτοιμο προς χρήση!")

; ============================================
; ΚΥΡΙΕΣ ΣΥΝΑΡΤΗΣΕΙΣ - ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
; ============================================

; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ ΠΕΡΙΟΔΟΥ
AutoSavePeriod() {
    global CurrentPeriod
    if CurrentPeriod = "" {
        return
    }
    SaveCurrentPeriodData()
}

; Νέα περίοδος με μεταφορά χρεών
NewPeriod(*) {
    global
    
    newPeriodName := EditPeriod.Value
    if newPeriodName = "" {
        MsgBox("Συμπληρώστε το όνομα της περιόδου!", "Σφάλμα", 0x10)
        return
    }
    
    if CurrentPeriod != "" {
        result := MsgBox("Θέλετε να αποθηκεύσετε την τρέχουσα περίοδο (" CurrentPeriod ") πριν δημιουργήσετε νέα;", "Αποθήκευση", 0x33)
        if result = "Yes" {
            AutoSavePeriod()
        } else if result = "Cancel" {
            return
        }
    }
    
    ; Υπολογισμός μη εξοφλημένων οφειλών
    unpaidDebt := 0
    tempPreviousDebts := Map()
    
    for apartment, debt in ApartmentDebts {
        if debt > 0.01 {
            unpaidDebt += debt
            tempPreviousDebts[apartment] := debt
        }
    }
    
    for apartment, debt in PreviousPeriodDebts {
        if tempPreviousDebts.Has(apartment) {
            tempPreviousDebts[apartment] += debt
        } else if debt > 0.01 {
            tempPreviousDebts[apartment] := debt
        }
        unpaidDebt += debt
    }
    
    CurrentPeriod := newPeriodName
    CreatePeriodFile()
    CreateTransactionsFile()
    
    PreviousPeriodDebts.Clear()
    for apartment, debt in tempPreviousDebts {
        if debt > 0.01 {
            PreviousPeriodDebts[apartment] := debt
        }
    }
    
    Treasury.PreviousDebt := unpaidDebt
    Treasury.TotalIncome := 0
    Treasury.TotalExpenses := 0
    Treasury.Transactions.Clear()
    ApartmentDebts.Clear()
    ApartmentPayments.Clear()
    Expenses.Clear()
    LVExpenses.Delete()
    UpdateExpenseTotals()

; Δημιουργία φακέλου περιόδου
CurrentPeriodFolder := A_ScriptDir "\" RegExReplace(newPeriodName, "[^\wΑ-Ωα-ω0-9]", "")
if !DirExist(CurrentPeriodFolder)
    DirCreate(CurrentPeriodFolder)
    
    AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
    
    AutoCalculateDebts()
    UpdateApartmentDebtsLV()
    UpdateTreasuryDisplay()
    UpdateTransactionsLV()
    
    MsgBox("Δημιουργήθηκε νέα περίοδος: " CurrentPeriod "`n`n" . 
           (unpaidDebt > 0 ? "Μεταφέρθηκαν " Format("{:.2f} €", unpaidDebt) " στο χρέος προηγούμενων περιόδων.`n`n" : "") .
           "Οφειλές ανά διαμέρισμα:" . GetDebtsSummary(), "Επιτυχία", 0x40)
}

; Αποθήκευση δεδομένων τρέχουσας περιόδου
SaveCurrentPeriodData() {
    global CurrentPeriod, Apartments, Treasury, ApartmentDebts, PreviousPeriodDebts, Expenses, ApartmentPayments, CurrentPeriodFolder
    
    if CurrentPeriod = "" || CurrentPeriodFolder = ""
        return
    
    ; Αλλαγή εδώ: Χρήση φακέλου περιόδου
    fileName := CurrentPeriodFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") ".ini"
    
    try {
        if FileExist(fileName)
            FileDelete(fileName)
        
        IniWrite(CurrentPeriod, fileName, "PeriodInfo", "Name")
        IniWrite(A_Now, fileName, "PeriodInfo", "LastModified")
        
        for apartment, data in Apartments {
            section := apartment
            IniWrite(data.owner, fileName, section, "Owner")
            IniWrite(data.phone, fileName, section, "Phone")
            IniWrite(data.common, fileName, section, "CommonPercent")
            IniWrite(data.elevator, fileName, section, "ElevatorPercent")
            IniWrite(data.heating, fileName, section, "HeatingPercent")
            IniWrite(data.percentage, fileName, section, "PrintingPercent")
            IniWrite(data.hasHeating, fileName, section, "HasHeating")
        }
        
        IniWrite(Treasury.Balance, fileName, "Treasury", "Balance")
        IniWrite(Treasury.PreviousDebt, fileName, "Treasury", "PreviousDebt")
        IniWrite(Treasury.TotalIncome, fileName, "Treasury", "TotalIncome")
        IniWrite(Treasury.TotalExpenses, fileName, "Treasury", "TotalExpenses")
        
        for apartment, debt in ApartmentDebts {
            if debt > 0.01 {
                IniWrite(Format("{:.2f}", debt), fileName, "CurrentDebts", apartment)
            }
        }
        
        for apartment, debt in PreviousPeriodDebts {
            if debt > 0.01 {
                IniWrite(Format("{:.2f}", debt), fileName, "PreviousDebts", apartment)
            }
        }
        
        for apartment, payment in ApartmentPayments {
            if payment > 0.01 {
                IniWrite(Format("{:.2f}", payment), fileName, "Payments", apartment)
            }
        }
        
        for id, expense in Expenses {
            IniWrite(expense.date, fileName, id, "Date")
            IniWrite(expense.amount, fileName, id, "Amount")
            IniWrite(expense.category, fileName, id, "Category")
            IniWrite(expense.type, fileName, id, "Type")
            IniWrite(expense.description, fileName, id, "Description")
        }
    }
}

GetDebtsSummary() {
    global PreviousPeriodDebts
    
    if PreviousPeriodDebts.Count = 0
        return "`n`nΔεν υπάρχουν ανεξόφλητα χρέη."
    
    summary := "`n"
    for apartment, debt in PreviousPeriodDebts {
        if debt > 0.01 {
            summary .= "`n• " apartment ": " Format("{:.2f} €", debt)
        }
    }
    return summary
}

; Προσθήκη διαμερίσματος
AddApartment(*) {
    global
    
    if !ValidateInputs()
        return
    
    apartment := EditApartment.Value
    if Apartments.Has(apartment) {
        MsgBox("Το διαμέρισμα " apartment " υπάρχει ήδη!", "Σφάλμα", 0x10)
        return
    }
    
    Apartments[apartment] := {
        owner: EditOwner.Value,
        phone: EditPhone.Value,
        common: Round(Number(EditCommon.Value), 2),
        elevator: Round(Number(EditElevator.Value), 2),
        heating: Round(Number(EditHeating.Value), 2),
        percentage: 0,
        hasHeating: CheckHeating.Value
    }
    
    RecalculateAllPercentages()
    UpdateLV()
    ClearFields()
    UpdateTotals()
    AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
    AutoCalculateDebts()
    UpdateReportsApartmentList()
}

; Επανυπολογισμός ποσοστών
RecalculateAllPercentages() {
    global Apartments
    
    if Apartments.Count = 0
        return
    
    newPercentage := Round(100 / Apartments.Count, 2)
    
    for apartment, data in Apartments {
        Apartments[apartment].percentage := newPercentage
    }
    
    UpdateLV()
    UpdateTotals()
}

; Αυτόματος υπολογισμός οφειλών - ΜΟΝΟ ΧΡΕΩΣΤΕΣ
AutoCalculateDebts() {
    global
    
    ; ═══════════════════════════════════════════════════════════
    ; ΚΡΙΣΙΜΟ: ΜΗΔΕΝΙΣΜΟΣ ΤΩΝ ΧΡΕΩΝ ΠΡΙΝ ΤΟΝ ΕΠΑΝΥΠΟΛΟΓΙΣΜΟ
    ; ═══════════════════════════════════════════════════════════
    ApartmentDebts.Clear()

    TotalHeating := 0
    for apartment, data in Apartments {
        if data.hasHeating
            TotalHeating += Number(data.heating)
    }
    
    totalCommonCost := GetExpenseTotal("Κοινόχρηστα")
    totalElevatorCost := GetExpenseTotal("Ασανσέρ")
    totalPrintingCost := GetExpenseTotal("Έκδοση")
    totalHeatingCost := GetExpenseTotal("Θέρμανση")
    totalReserveCost := GetExpenseTotal("Αποθεματικό")
    
    TotalCommonCostText.Text := Format("{:.2f} €", totalCommonCost)
    TotalElevatorCostText.Text := Format("{:.2f} €", totalElevatorCost)
    TotalPrintingCostText.Text := Format("{:.2f} €", totalPrintingCost)
    TotalHeatingCostText.Text := Format("{:.2f} €", totalHeatingCost)
    TotalReserveCostText.Text := Format("{:.2f} €", totalReserveCost)
    TotalAllCostsText.Text := Format("{:.2f} €", totalCommonCost + totalElevatorCost + totalPrintingCost + totalHeatingCost + totalReserveCost)
    
    LVDebts.Delete()
    
    totalDebtCommon := 0
    totalDebtElevator := 0
    totalDebtPrinting := 0
    totalDebtHeating := 0
    totalDebtReserve := 0
    totalAllDebts := 0

    for apartment, data in Apartments {
        commonDebt := (Number(data.common) / 1000) * totalCommonCost
        elevatorDebt := (Number(data.elevator) / 1000) * totalElevatorCost
        printingDebt := (Number(data.percentage) / 100) * totalPrintingCost
        reserveDebt := (Number(data.common) / 1000) * totalReserveCost
        
        heatingDebt := 0
        if data.hasHeating && TotalHeating > 0
            heatingDebt := (Number(data.heating) / TotalHeating) * totalHeatingCost
        
        calculatedPeriodDebt := commonDebt + elevatorDebt + printingDebt + heatingDebt + reserveDebt
        paidAmount := ApartmentPayments.Has(apartment) ? ApartmentPayments[apartment] : 0
        actualPeriodDebt := Max(0, calculatedPeriodDebt - paidAmount)
        
        if (totalCommonCost + totalElevatorCost + totalPrintingCost + totalHeatingCost + totalReserveCost) > 0.01 {
            ApartmentDebts[apartment] := actualPeriodDebt
        } else {
            actualPeriodDebt := ApartmentDebts.Has(apartment) ? ApartmentDebts[apartment] : 0
        }
        
        previousDebt := PreviousPeriodDebts.Has(apartment) ? Number(PreviousPeriodDebts[apartment]) : 0
        totalDebt := actualPeriodDebt + previousDebt
        
        ; ΚΡΙΣΙΜΟ: Εμφάνιση ΜΟΝΟ αν χρωστάει
        if totalDebt > 0.01 {
            LVDebts.Add("", apartment, data.owner,
                       Format("{:.2f} €", commonDebt),
                       Format("{:.2f} €", elevatorDebt),
                       Format("{:.2f} €", printingDebt),
                       Format("{:.2f} €", heatingDebt),
                       Format("{:.2f} €", reserveDebt),
                       Format("{:.2f} €", actualPeriodDebt),
                       Format("{:.2f} €", previousDebt),
                       Format("{:.2f} €", totalDebt))
            
            totalDebtCommon += commonDebt
            totalDebtElevator += elevatorDebt
            totalDebtPrinting += printingDebt
            totalDebtHeating += heatingDebt
            totalDebtReserve += reserveDebt
            totalAllDebts += totalDebt
        }
    }
    
    TotalDebtCommonText.Text := Format("{:.2f} €", totalDebtCommon)
    TotalDebtElevatorText.Text := Format("{:.2f} €", totalDebtElevator)
    TotalDebtPrintingText.Text := Format("{:.2f} €", totalDebtPrinting)
    TotalDebtHeatingText.Text := Format("{:.2f} €", totalDebtHeating)
    TotalAllDebtsText.Text := Format("{:.2f} €", totalAllDebts)

    UpdateApartmentDebtsLV()
    UpdateTreasuryDisplay()
}

; Ενημέρωση εμφάνισης ταμείου
UpdateTreasuryDisplay() {
    global CurrentBalanceText, PreviousDebtText, TotalIncomeText, TotalExpensesText, NetBalanceText, Treasury
    
    CurrentBalanceText.Text := Format("{:.2f} €", Treasury.Balance)
    
    ; ΑΥΤΟΜΑΤΟΣ ΥΠΟΛΟΓΙΣΜΟΣ ΧΡΩΣΤΟΥΜΕΝΩΝ
    totalDebts := CalculateTotalDebts()
    PreviousDebtText.Text := Format("{:.2f} €", totalDebts)
    
    TotalIncomeText.Text := Format("{:.2f} €", Treasury.TotalIncome)
    TotalExpensesText.Text := Format("{:.2f} €", Treasury.TotalExpenses)
    
    ; ΝΕΟΣ ΥΠΟΛΟΓΙΣΜΟΣ: Διαθέσιμο = Μετρητά + Χρεωστά
    netBalance := Treasury.Balance + totalDebts
    NetBalanceText.Text := Format("{:.2f} €", netBalance)
    
if netBalance >= 0
    NetBalanceText.SetFont("s11 Bold c0x1B5E20")
else
    NetBalanceText.SetFont("s11 Bold c0xC62828")
}

; Ενημέρωση ιστορικού συναλλαγών
UpdateTransactionsLV() {
    global LVTransactions, Treasury
    
    LVTransactions.Delete()
    
    for id, transaction in Treasury.Transactions {
        LVTransactions.Add(, transaction.date,
                          Format("{:.2f} €", transaction.amount),
                          transaction.type,
                          transaction.description,
                          transaction.apartment)
    }
}

; Αλλαγή καρτέλας
TabChanged(Ctrl, Info) {
    if Info = 4 {
        AutoCalculateDebts()
    }
    else if Info = 6 {
        UpdateReportsApartmentList()
        UpdateTreasuryDisplay()
        UpdateTransactionsLV()
        UpdateApartmentDebtsLV()
    }
}

; Υπολογισμός συνολικών χρεών όλων των διαμερισμάτων
CalculateTotalDebts() {
    global ApartmentDebts, PreviousPeriodDebts, Apartments
    
    totalCurrentDebts := 0
    totalPreviousDebts := 0
    
    ; Υπολογισμός χρεών τρέχουσας περιόδου
    for apartment, debt in ApartmentDebts {
        if debt > 0.01 {
            totalCurrentDebts += debt
        }
    }
    
    ; Υπολογισμός χρεών προηγούμενων περιόδων
    for apartment, debt in PreviousPeriodDebts {
        if debt > 0.01 {
            totalPreviousDebts += debt
        }
    }
    
    return totalCurrentDebts + totalPreviousDebts
}

; ΦΟΡΤΩΣΗ ΠΕΡΙΟΔΟΥ με ΛΕΠΤΟΜΕΡΕΙΣ ΠΛΗΡΟΦΟΡΙΕΣ
LoadPeriod(*) {
    global
    
    SelectedFile := FileSelect("3", , "Φόρτωση Περιόδου", "INI Files (*.ini)")
    if SelectedFile = ""
        return
    
    try {
        ; ΝΕΟ: Ορισμός φακέλου περιόδου από το επιλεγμένο αρχείο
        CurrentPeriodFolder := DirExist(SelectedFile) ? SelectedFile : SubStr(SelectedFile, 1, InStr(SelectedFile, "\", , -1) - 1)
        
        Expenses.Clear()
        CurrentPeriod := ""
        ApartmentDebts.Clear()
        PreviousPeriodDebts.Clear()
        ApartmentPayments.Clear()
        Treasury.Transactions.Clear()
        
        sections := IniRead(SelectedFile)
        if sections = "ERROR" || sections = "" {
            MsgBox("Το αρχείο είναι κενό!", "Πληροφορία", 0x40)
            return
        }
        
        sectionArray := StrSplit(sections, "`n")
        expenseCount := 0
        
        for section in sectionArray {
            section := Trim(section)
            
            if section = "" || section = "PeriodInfo" || section = "Treasury" 
                || section = "CurrentDebts" || section = "PreviousDebts" || section = "Payments"
                continue
            
            ownerCheck := IniRead(SelectedFile, section, "Owner", "ERROR")
            
            if ownerCheck != "ERROR" {
                Apartments[section] := {
                    owner: ownerCheck,
                    phone: IniRead(SelectedFile, section, "Phone", ""),
                    common: Round(Number(IniRead(SelectedFile, section, "CommonPercent", "0")), 2),
                    elevator: Round(Number(IniRead(SelectedFile, section, "ElevatorPercent", "0")), 2),
                    heating: Round(Number(IniRead(SelectedFile, section, "HeatingPercent", "0")), 2),
                    percentage: Round(Number(IniRead(SelectedFile, section, "PrintingPercent", "0")), 2),
                    hasHeating: (IniRead(SelectedFile, section, "HasHeating", "0") = "1") ? 1 : 0
                }
            } else {
                amount := IniRead(SelectedFile, section, "Amount", "ERROR")
                if amount != "ERROR" {
                    Expenses[section] := {
                        amount: Number(amount),
                        category: IniRead(SelectedFile, section, "Category", ""),
                        type: IniRead(SelectedFile, section, "Type", ""),
                        description: IniRead(SelectedFile, section, "Description", ""),
                        date: IniRead(SelectedFile, section, "Date", "")
                    }
                    expenseCount++
                }
            }
        }
        
        periodName := IniRead(SelectedFile, "PeriodInfo", "Name", "")
        if periodName != "" {
            CurrentPeriod := periodName
            EditPeriod.Value := periodName
        }
        
        Treasury.Balance := Number(IniRead(SelectedFile, "Treasury", "Balance", "0"))
        Treasury.TotalIncome := Number(IniRead(SelectedFile, "Treasury", "TotalIncome", "0"))
        Treasury.TotalExpenses := Number(IniRead(SelectedFile, "Treasury", "TotalExpenses", "0"))
        
; ΚΡΙΣΙΜΟ: Φόρτωση PreviousDebts ΠΡΙΝ τον υπολογισμό του Treasury.PreviousDebt
previousDebtSections := IniRead(SelectedFile, "PreviousDebts", , "")
if previousDebtSections != "" && previousDebtSections != "ERROR" {
    debtArray := StrSplit(previousDebtSections, "`n")
    for debtLine in debtArray {
        debtLine := Trim(debtLine)
        if debtLine != "" {
            ; ΚΡΙΣΙΜΟ: Διαχωρισμός του key=value
            parts := StrSplit(debtLine, "=")
            if parts.Length >= 2 {
                aptName := Trim(parts[1])
                debtValue := Number(Trim(parts[2]))
                if debtValue > 0.01 {
                    PreviousPeriodDebts[aptName] := debtValue
                }
            }
        }
    }
}
        
        ; ΚΡΙΣΙΜΟ: Υπολογισμός Treasury.PreviousDebt από τα φορτωμένα PreviousPeriodDebts
        totalPrevDebts := 0
        for apartment, debt in PreviousPeriodDebts {
            if debt > 0.01 {
                totalPrevDebts += debt
            }
        }
        Treasury.PreviousDebt := totalPrevDebts
        
currentDebtSections := IniRead(SelectedFile, "CurrentDebts", , "")
if currentDebtSections != "" && currentDebtSections != "ERROR" {
    debtArray := StrSplit(currentDebtSections, "`n")
    for debtLine in debtArray {
        debtLine := Trim(debtLine)
        if debtLine != "" {
            ; ΚΡΙΣΙΜΟ: Διαχωρισμός του key=value
            parts := StrSplit(debtLine, "=")
            if parts.Length >= 2 {
                aptName := Trim(parts[1])
                debtValue := Number(Trim(parts[2]))
                if debtValue > 0.01 {
                    ApartmentDebts[aptName] := debtValue
                }
            }
        }
    }
}
        
        paymentSections := IniRead(SelectedFile, "Payments", , "")
        if paymentSections != "" && paymentSections != "ERROR" {
            paymentArray := StrSplit(paymentSections, "`n")
            for paymentLine in paymentArray {
                paymentLine := Trim(paymentLine)
                if paymentLine != "" {
                    parts := StrSplit(paymentLine, "=")
                    if parts.Length >= 2 {
                        aptName := Trim(parts[1])
                        payment := Number(Trim(parts[2]))
                        if payment > 0.01 {
                            ApartmentPayments[aptName] := payment
                        }
                    }
                }
            }
        }
        
if CurrentPeriod != "" {
    ; Αλλαγή εδώ: Χρήση φακέλου περιόδου
    transactionsFile := CurrentPeriodFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_Transactions.ini"
    
    if FileExist(transactionsFile) {
                try {
                    transSections := IniRead(transactionsFile)
                    if transSections != "ERROR" && transSections != "" {
                        transArray := StrSplit(transSections, "`n")
                        
                        for transSection in transArray {
                            transSection := Trim(transSection)
                            
                            if transSection = "" || transSection = "TransactionsInfo"
                                continue
                            

date := IniRead(transactionsFile, transSection, "Date", "")
                            if date != "" && date != "ERROR" {
                                transData := {
                                    date: date,
                                    amount: Number(IniRead(transactionsFile, transSection, "Amount", "0")),
                                    type: IniRead(transactionsFile, transSection, "Type", ""),
                                    description: IniRead(transactionsFile, transSection, "Description", ""),
                                    apartment: IniRead(transactionsFile, transSection, "Apartment", "")
                                }
                                
                                ; ΚΡΙΣΙΜΟ: Φορτώνουμε και την ανάλυση πληρωμής αν υπάρχει
                                paidCurrent := IniRead(transactionsFile, transSection, "PaidCurrentDebt", "ERROR")
                                if paidCurrent != "ERROR" && paidCurrent != "" {
                                    transData.paidCurrentDebt := Number(paidCurrent)
                                }
                                
                                paidPrevious := IniRead(transactionsFile, transSection, "PaidPreviousDebt", "ERROR")
                                if paidPrevious != "ERROR" && paidPrevious != "" {
                                    transData.paidPreviousDebt := Number(paidPrevious)
                                }
                                
                                Treasury.Transactions[transSection] := transData
                            }

                        }
                    }
                }
            }
        }
        
        UpdateLV()
        UpdateTotals()
        UpdateExpenseLV()
        UpdateExpenseTotals()
        UpdateTreasuryDisplay()
        AutoCalculateDebts()
        UpdateApartmentDebtsLV()
        UpdateTransactionsLV()
        UpdateReportsApartmentList()
        
        ; ΛΕΠΤΟΜΕΡΕΙΣ ΠΛΗΡΟΦΟΡΙΕΣ ΦΟΡΤΩΣΗΣ
        countDebtors := 0
        countPaid := 0
        debtsSummary := ""
        
        ; Μετράμε διαμερίσματα που χρωστούν
        for apartment, data in Apartments {
            currentDebt := ApartmentDebts.Has(apartment) ? ApartmentDebts[apartment] : 0
            previousDebt := PreviousPeriodDebts.Has(apartment) ? PreviousPeriodDebts[apartment] : 0
            totalDebt := currentDebt + previousDebt
            
            if totalDebt > 0.01 {
                countDebtors++
                debtsSummary .= "`n  • " apartment ": " Format("{:.2f} €", totalDebt) 
                debtsSummary .= " (Τρέχον: " Format("{:.2f}", currentDebt) 
                debtsSummary .= ", Προηγ: " Format("{:.2f}", previousDebt) ")"
            }
        }
        
        countPaid := Apartments.Count - countDebtors
        
        msg := "✓ ΦΟΡΤΩΘΗΚΕ ΠΕΡΙΟΔΟΣ: " CurrentPeriod 
        msg .= "`n`n════════════════════════════════════"
        msg .= "`n📊 ΓΕΝΙΚΑ ΣΤΟΙΧΕΙΑ:"
        msg .= "`n════════════════════════════════════"
        msg .= "`n• Έξοδα: " expenseCount 
        msg .= "`n• Διαμερίσματα: " Apartments.Count 
        msg .= "`n• Συναλλαγές: " Treasury.Transactions.Count
        
        msg .= "`n`n════════════════════════════════════"
        msg .= "`n💰 ΟΙΚΟΝΟΜΙΚΑ ΣΤΟΙΧΕΙΑ:"
        msg .= "`n════════════════════════════════════"
        msg .= "`n• Μετρητά Ταμείου: " Format("{:.2f} €", Treasury.Balance)
        msg .= "`n• Εισπράξεις: " Format("{:.2f} €", Treasury.TotalIncome)
        msg .= "`n• Έξοδα: " Format("{:.2f} €", Treasury.TotalExpenses)
        msg .= "`n• Διαθέσιμο: " Format("{:.2f} €", Treasury.Balance)
        
        msg .= "`n`n════════════════════════════════════"
        msg .= "`n📋 ΚΑΤΑΣΤΑΣΗ ΟΦΕΙΛΩΝ:"
        msg .= "`n════════════════════════════════════"
        msg .= "`n• Διαμερίσματα που ΧΡΩΣΤΟΥΝ: " countDebtors
        msg .= "`n• Διαμερίσματα που ΞΕΧΡΕΩΣΑΝ: " countPaid
        msg .= "`n• Συνολικά Χρωστούμενα: " Format("{:.2f} €", Treasury.PreviousDebt)
        
        if countDebtors > 0 {
            msg .= "`n`n════════════════════════════════════"
            msg .= "`n⚠️ ΧΡΕΗ ΑΝΑ ΔΙΑΜΕΡΙΣΜΑ:"
            msg .= "`n════════════════════════════════════"
            msg .= debtsSummary
        } else {
            msg .= "`n`n✓ ΟΛΑ ΤΑ ΔΙΑΜΕΡΙΣΜΑΤΑ ΕΧΟΥΝ ΞΕΧΡΕΩΣΕΙ!"
        }
        
        totalPaid := 0
        for apt, paid in ApartmentPayments {
            totalPaid += paid
        }
        if totalPaid > 0 {
            msg .= "`n`n════════════════════════════════════"
            msg .= "`n✓ Εξοφλήθηκαν: " Format("{:.2f} €", totalPaid)
        }
        
        MsgBox(msg, "Επιτυχής Φόρτωση Περιόδου", 0x40)
        
    } catch as e {
        MsgBox("Σφάλμα κατά τη φόρτωση: " e.Message "`n`nLine: " e.Line, "Σφάλμα", 0x10)
    }
}

; Εμφάνιση παραθύρου εξόδων
ShowExpenseWindow(*) {
    global
    if CurrentPeriod = "" {
        MsgBox("Δημιουργήστε πρώτα μια περίοδο!", "Σφάλμα", 0x10)
        return
    }
    
    ExpenseGui := Gui("+Owner" MyGui.Hwnd, "Προσθήκη Εξόδου")
    ExpenseGui.OnEvent("Close", (*) => ExpenseGui.Destroy())
    ExpenseGui.SetFont("s10", "Segoe UI")
    
    ExpenseGui.Add("Text", "x20 y20 w100", "Ημερομηνία:")
    EditExpenseDate := ExpenseGui.Add("Edit", "x130 y20 w150", A_YYYY "-" A_MM "-" A_DD)
    ExpenseGui.Add("Text", "x20 y60 w100", "Ποσό:")
    EditExpenseAmount := ExpenseGui.Add("Edit", "x130 y60 w150", "0.00")
    ExpenseGui.Add("Text", "x20 y100 w100", "Κατηγορία:")
    DropdownCategory := ExpenseGui.Add("DropDownList", "x130 y100 w200", ExpenseCategories)
    ExpenseGui.Add("Text", "x20 y140 w100", "Είδος:")
    DropdownType := ExpenseGui.Add("DropDownList", "x130 y140 w200", [])
    ExpenseGui.Add("Text", "x20 y180 w100", "Περιγραφή:")
    EditExpenseDesc := ExpenseGui.Add("Edit", "x130 y180 w300 h80", "")
    
    BtnSaveExpense := ExpenseGui.Add("Button", "x130 y280 w120 h35", "Αποθήκευση")
    BtnSaveExpense.OnEvent("Click", SaveExpense)
    BtnCancelExpense := ExpenseGui.Add("Button", "x260 y280 w120 h35", "Ακύρωση")
    BtnCancelExpense.OnEvent("Click", (*) => ExpenseGui.Destroy())
    
    UpdateExpenseTypes(category) {
        DropdownType.Delete()
        if ExpenseTypes.Has(category) {
            for index, expenseType in ExpenseTypes[category] {
                DropdownType.Add([expenseType])
            }
        }
        try {
            DropdownType.Choose(1)  ; Αυτόματη επιλογή πρώτου είδους
        }
    }
    
    ; ΑΥΤΟΜΑΤΗ ΕΠΙΛΟΓΗ ΠΡΩΤΗΣ ΚΑΤΗΓΟΡΙΑΣ ΚΑΙ ΠΡΩΤΟΥ ΕΙΔΟΥΣ
    DropdownCategory.Choose(1)  ; Επιλέγει "Κοινόχρηστα"
    UpdateExpenseTypes(ExpenseCategories[1])  ; Φορτώνει τα είδη για "Κοινόχρηστα"
    
    DropdownCategory.OnEvent("Change", (*) => UpdateExpenseTypes(DropdownCategory.Text))
    
    SaveExpense(*) {
        if EditExpenseDate.Value = "" {
            MsgBox("Συμπληρώστε την ημερομηνία!", "Σφάλμα", 0x10)
            return
        }
        
        try {
            amount := Number(EditExpenseAmount.Value)
            if amount <= 0 {
                MsgBox("Το ποσό πρέπει να είναι μεγαλύτερο από 0!", "Σφάλμα", 0x10)
                return
            }
        } catch {
            MsgBox("Το ποσό πρέπει να είναι αριθμός!", "Σφάλμα", 0x10)
            return
        }
        
        if DropdownCategory.Text = "" {
            MsgBox("Επιλέξτε κατηγορία!", "Σφάλμα", 0x10)
            return
        }
        
        if DropdownType.Text = "" {
            MsgBox("Επιλέξτε είδος!", "Σφάλμα", 0x10)
            return
        }
        
        expenseID := "Expense_" A_Now
        
        Expenses[expenseID] := {
            date: EditExpenseDate.Value,
            amount: amount,
            category: DropdownCategory.Text,
            type: DropdownType.Text,
            description: EditExpenseDesc.Value
        }
        
        if DropdownCategory.Text != "Αποθεματικό" {
            Treasury.Balance -= amount
            Treasury.TotalExpenses += amount
        }

        transaction := {
            date: EditExpenseDate.Value,
            amount: -amount,
            type: "Έξοδο",
            description: DropdownCategory.Text " - " DropdownType.Text,
            apartment: ""
        }

        ; ΚΡΙΣΙΜΟ: Χρησιμοποιούμε το ID που επιστρέφει η SaveTransactionToFile
        transactionID := SaveTransactionToFile(transaction)
        if transactionID != "" {
            Treasury.Transactions[transactionID] := transaction
        }
        
        AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
        
        UpdateExpenseLV()
        UpdateExpenseTotals()
        UpdateTreasuryDisplay()
        UpdateTransactionsLV()
        AutoCalculateDebts()
        
        ExpenseGui.Destroy()
        MsgBox("Το έξοδο προστέθηκε επιτυχώς!`n`n✓ Αποθηκεύτηκε αυτόματα!", "Επιτυχία", 0x40)
    }
    
    ExpenseGui.Show("w450 h350")
}

; Ενημέρωση λίστας εξόδων
UpdateExpenseLV() {
    global LVExpenses, Expenses
    LVExpenses.Delete()
    
    for id, expense in Expenses {
        LVExpenses.Add("", expense.date, Format("{:.2f} €", expense.amount), 
                      expense.category, expense.type, expense.description)
    }
}

; Ενημέρωση συνολικών εξόδων
UpdateExpenseTotals() {
    global
    totalCommon := 0, totalElevator := 0, totalHeating := 0, totalPrinting := 0, totalReserve := 0
    
    for id, expense in Expenses {
        amount := Number(expense.amount)
        switch expense.category {
            case "Κοινόχρηστα": totalCommon += amount
            case "Ασανσέρ": totalElevator += amount
            case "Θέρμανση": totalHeating += amount
            case "Έκδοση": totalPrinting += amount
            case "Αποθεματικό": totalReserve += amount
        }
    }
    
    TotalCommonExpenses.Text := Format("{:.2f} €", totalCommon)
    TotalElevatorExpenses.Text := Format("{:.2f} €", totalElevator)
    TotalHeatingExpenses.Text := Format("{:.2f} €", totalHeating)
    TotalPrintingExpenses.Text := Format("{:.2f} €", totalPrinting)
    TotalReserveExpenses.Text := Format("{:.2f} €", totalReserve)
    TotalAllExpenses.Text := Format("{:.2f} €", totalCommon + totalElevator + totalHeating + totalPrinting + totalReserve)
}

; Επικύρωση εισόδων
ValidateInputs() {
    if !EditApartment.Value {
        MsgBox("Συμπληρώστε το διαμέρισμα!", "Σφάλμα", 0x10)
        return false
    }
    
    if !EditOwner.Value {
        MsgBox("Συμπληρώστε το όνομα ιδιοκτήτη!", "Σφάλμα", 0x10)
        return false
    }
    
    try {
        common := Number(EditCommon.Value)
        elevator := Number(EditElevator.Value)
        heating := Number(EditHeating.Value)
    } catch {
        MsgBox("Τα πεδία χιλιοστών πρέπει να είναι αριθμοί!", "Σφάλμα", 0x10)
        return false
    }
    
    if common < 0 || elevator < 0 || heating < 0 {
        MsgBox("Τα χιλιοστά δεν μπορούν να είναι αρνητικά!", "Σφάλμα", 0x10)
        return false
    }
    
    return true
}

; Ενημέρωση λίστας
UpdateLV() {
    global LV, Apartments
    LV.Delete()
    
    for apartment, data in Apartments {
        heatingStatus := data.hasHeating ? "Ναι" : "Όχι"
        LV.Add("", apartment, data.owner, data.phone, 
               data.common,
               data.elevator, 
               data.heating, 
               data.percentage "%",
               heatingStatus)
    }
    
    UpdateLVTotals()
}

; Ενημέρωση συνόλων στη λίστα
UpdateLVTotals() {
    global
    totalCommon := 0, totalElevator := 0, totalHeating := 0, totalPercentage := 0
    
    for apartment, data in Apartments {
        totalCommon += Number(data.common)
        totalElevator += Number(data.elevator)
        totalHeating += Number(data.heating)
        totalPercentage += Number(data.percentage)
    }
    
    LVTotalCommon.Text := Format("{:.2f}", totalCommon)
    LVTotalElevator.Text := Format("{:.2f}", totalElevator)
    LVTotalHeating.Text := Format("{:.2f}", totalHeating)
    LVTotalPercentage.Text := Format("{:.2f}", totalPercentage) " %"
}

; Καθαρισμός πεδίων
ClearFields(*) {
    global
    EditApartment.Value := ""
    EditOwner.Value := ""
    EditPhone.Value := ""
    EditCommon.Value := ""
    EditElevator.Value := ""
    EditHeating.Value := ""
    EditPercentage.Value := ""
    CheckHeating.Value := 1
    CurrentEditIndex := 0
    BtnUpdate.Enabled := false
    BtnDelete.Enabled := false
    BtnAdd.Enabled := true
}

; Διπλό κλικ στη λίστα
LV_DoubleClick(LV, Row) {
    global
    if Row = 0
        return
    
    apartment := LV.GetText(Row, 1)
    if !Apartments.Has(apartment)
        return
    
    data := Apartments[apartment]
    EditApartment.Value := apartment
    EditOwner.Value := data.owner
    EditPhone.Value := data.phone
    EditCommon.Value := data.common
    EditElevator.Value := data.elevator
    EditHeating.Value := data.heating
    EditPercentage.Value := data.percentage
    CheckHeating.Value := data.hasHeating
    
    CurrentEditIndex := Row
    BtnUpdate.Enabled := true
    BtnDelete.Enabled := true
    BtnAdd.Enabled := false
    
    TabCtrl.Choose(2)
}

; Ενημέρωση διαμερίσματος
UpdateApartment(*) {
    global
    
    if CurrentEditIndex = 0 || !ValidateInputs()
        return
    
    apartment := EditApartment.Value
    oldApartment := LV.GetText(CurrentEditIndex, 1)
    
    if (apartment != oldApartment && Apartments.Has(apartment)) {
        MsgBox("Το διαμέρισμα " apartment " υπάρχει ήδη!", "Σφάλμα", 0x10)
        return
    }
    
    if (apartment != oldApartment) {
        Apartments.Delete(oldApartment)
    }
    
    Apartments[apartment] := {
        owner: EditOwner.Value,
        phone: EditPhone.Value,
        common: Round(Number(EditCommon.Value), 2),
        elevator: Round(Number(EditElevator.Value), 2),
        heating: Round(Number(EditHeating.Value), 2),
        percentage: 0,
        hasHeating: CheckHeating.Value
    }
    
    RecalculateAllPercentages()
    UpdateLV()
    ClearFields()
    UpdateTotals()
    AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
    AutoCalculateDebts()
    UpdateReportsApartmentList()
}

; Διαγραφή διαμερίσματος
DeleteApartment(*) {
    global
    
    if CurrentEditIndex = 0
        return
    
    apartment := LV.GetText(CurrentEditIndex, 1)
    
    if MsgBox("Θέλετε να διαγράψετε το διαμέρισμα " apartment "?", "Διαγραφή", 0x34) = "Yes" {
        Apartments.Delete(apartment)
        RecalculateAllPercentages()
        UpdateLV()
        ClearFields()
        UpdateTotals()
        AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
        AutoCalculateDebts()
        UpdateReportsApartmentList()
    }
}

; Ταξινόμηση λίστας
SortLV(Column) {
    global
    static SortDirection := Map()
    
    if !SortDirection.Has(Column)
        SortDirection[Column] := "Desc"
    
    if SortDirection[Column] = "Desc" {
        LV.ModifyCol(Column, "Sort")
        SortDirection[Column] := "Asc"
    } else {
        LV.ModifyCol(Column, "SortDesc")
        SortDirection[Column] := "Desc"
    }
}

; Αποθήκευση σε INI
SaveToINI(*) {
    global Apartments, Treasury, PreviousPeriodDebts, ApartmentDebts, CurrentPeriod, ApartmentPayments
    
    if Apartments.Count = 0 {
        MsgBox("Δεν υπάρχουν δεδομένα για αποθήκευση!", "Πληροφορία", 0x40)
        return
    }
    
    SelectedFile := FileSelect("S16", "Apartments.ini", "Αποθήκευση INI", "INI Files (*.ini)")
    if SelectedFile = ""
        return
    
    try {
        if FileExist(SelectedFile)
            FileDelete(SelectedFile)
        
        for apartment, data in Apartments {
            section := apartment
            IniWrite(data.owner, SelectedFile, section, "Owner")
            IniWrite(data.phone, SelectedFile, section, "Phone")
            IniWrite(data.common, SelectedFile, section, "CommonPercent")
            IniWrite(data.elevator, SelectedFile, section, "ElevatorPercent")
            IniWrite(data.heating, SelectedFile, section, "HeatingPercent")
            IniWrite(data.percentage, SelectedFile, section, "PrintingPercent")
            IniWrite(data.hasHeating, SelectedFile, section, "HasHeating")
        }
        
        IniWrite(Treasury.Balance, SelectedFile, "Treasury", "Balance")
        IniWrite(Treasury.PreviousDebt, SelectedFile, "Treasury", "PreviousDebt")
        IniWrite(Treasury.TotalIncome, SelectedFile, "Treasury", "TotalIncome")
        IniWrite(Treasury.TotalExpenses, SelectedFile, "Treasury", "TotalExpenses")
        
        for apartment, debt in ApartmentDebts {
            if debt > 0.01 {
                IniWrite(Format("{:.2f}", debt), SelectedFile, "CurrentDebts", apartment)
            }
        }
        
        for apartment, debt in PreviousPeriodDebts {
            if debt > 0.01 {
                IniWrite(Format("{:.2f}", debt), SelectedFile, "PreviousDebts", apartment)
            }
        }
        
        for apartment, payment in ApartmentPayments {
            if payment > 0.01 {
                IniWrite(Format("{:.2f}", payment), SelectedFile, "Payments", apartment)
            }
        }
        
        if CurrentPeriod != "" {
            IniWrite(CurrentPeriod, SelectedFile, "PeriodInfo", "Name")
            IniWrite(A_Now, SelectedFile, "PeriodInfo", "LastSaved")
        }
        
        MsgBox("Τα δεδομένα αποθηκεύτηκαν επιτυχώς!", "Επιτυχία", 0x40)
    } catch as e {
        MsgBox("Σφάλμα κατά την αποθήκευση: " e.Message, "Σφάλμα", 0x10)
    }
}

; Φόρτωση από INI
LoadFromINI(*) {
    global Apartments, Treasury, PreviousPeriodDebts, ApartmentDebts, CurrentPeriod, ApartmentPayments
    
    SelectedFile := FileSelect("3", , "Φόρτωση από INI", "INI Files (*.ini)")
    if SelectedFile = ""
        return
    
    try {
        Apartments.Clear()
        PreviousPeriodDebts.Clear()
        ApartmentDebts.Clear()
        ApartmentPayments.Clear()
        
        if !FileExist(SelectedFile) {
            MsgBox("Το αρχείο δεν βρέθηκε!", "Σφάλμα", 0x10)
            return
        }
        
        sections := IniRead(SelectedFile)
        if sections = "ERROR" || sections = "" {
            MsgBox("Το αρχείο INI είναι κενό!", "Πληροφορία", 0x40)
            return
        }
        
        sectionArray := StrSplit(sections, "`n")
        loadedApartments := 0
        
        for section in sectionArray {
            section := Trim(section)
            if section = "" || section = "Treasury" || section = "PreviousDebts" || section = "CurrentDebts" || section = "PeriodInfo" || section = "Payments"
                continue
                
            apartment := section
            
            owner := IniRead(SelectedFile, section, "Owner", "")
            phone := IniRead(SelectedFile, section, "Phone", "")
            common := IniRead(SelectedFile, section, "CommonPercent", "0")
            elevator := IniRead(SelectedFile, section, "ElevatorPercent", "0")
            heating := IniRead(SelectedFile, section, "HeatingPercent", "0")
            percentage := IniRead(SelectedFile, section, "PrintingPercent", "0")
            hasHeating := IniRead(SelectedFile, section, "HasHeating", "0")
            
            if owner != "" {
                Apartments[apartment] := {
                    owner: owner,
                    phone: phone,
                    common: Round(Number(common), 2),
                    elevator: Round(Number(elevator), 2),
                    heating: Round(Number(heating), 2),
                    percentage: Round(Number(percentage), 2),
                    hasHeating: (hasHeating = "1") ? 1 : 0
                }
                loadedApartments++
            }
        }
        
        try {
            Treasury.Balance := Number(IniRead(SelectedFile, "Treasury", "Balance", "0"))
            Treasury.PreviousDebt := Number(IniRead(SelectedFile, "Treasury", "PreviousDebt", "0"))
            Treasury.TotalIncome := Number(IniRead(SelectedFile, "Treasury", "TotalIncome", "0"))
            Treasury.TotalExpenses := Number(IniRead(SelectedFile, "Treasury", "TotalExpenses", "0"))
        } catch {
            Treasury.Balance := 0
            Treasury.PreviousDebt := 0
            Treasury.TotalIncome := 0
            Treasury.TotalExpenses := 0
        }
        
        try {
            currentDebtSections := IniRead(SelectedFile, "CurrentDebts")
            if currentDebtSections != "ERROR" && currentDebtSections != "" {
                debtArray := StrSplit(currentDebtSections, "`n")
                for debtLine in debtArray {
                    debtLine := Trim(debtLine)
                    if debtLine != "" {
                        try {
                            debt := Number(IniRead(SelectedFile, "CurrentDebts", debtLine, "0"))
                            if debt > 0 {
                                ApartmentDebts[debtLine] := debt
                            }
                        }
                    }
                }
            }
        }
        
        try {
            debtSections := IniRead(SelectedFile, "PreviousDebts")
            if debtSections != "ERROR" && debtSections != "" {
                debtArray := StrSplit(debtSections, "`n")
                for debtLine in debtArray {
                    debtLine := Trim(debtLine)
                    if debtLine != "" {
                        try {
                            debt := Number(IniRead(SelectedFile, "PreviousDebts", debtLine, "0"))
                            if debt > 0 {
                                PreviousPeriodDebts[debtLine] := debt
                            }
                        }
                    }
                }
            }
        }
        
        try {
            paymentSections := IniRead(SelectedFile, "Payments")
            if paymentSections != "ERROR" && paymentSections != "" {
                paymentArray := StrSplit(paymentSections, "`n")
                for paymentLine in paymentArray {
                    paymentLine := Trim(paymentLine)
                    if paymentLine != "" {
                        try {
                            payment := Number(IniRead(SelectedFile, "Payments", paymentLine, "0"))
                            if payment > 0 {
                                ApartmentPayments[paymentLine] := payment
                            }
                        }
                    }
                }
            }
        }
        
        try {
            periodName := IniRead(SelectedFile, "PeriodInfo", "Name", "")
            if periodName != "" {
                CurrentPeriod := periodName
                EditPeriod.Value := periodName
            }
        }
        
        UpdateLV()
        UpdateTotals()
        UpdateTreasuryDisplay()
        AutoCalculateDebts() 
        UpdateApartmentDebtsLV()
        UpdateReportsApartmentList()
        
        if loadedApartments > 0 {
            MsgBox("Τα δεδομένα φορτώθηκαν επιτυχώς!`n" loadedApartments " διαμερίσματα`nΤαμείο: " Format("{:.2f} €", Treasury.Balance) "`nΧρέη Προηγ.: " Format("{:.2f} €", Treasury.PreviousDebt), "Επιτυχία", 0x40)
        } else {
            MsgBox("Δεν βρέθηκαν διαμερίσματα στο αρχείο.", "Πληροφορία", 0x40)
        }
    } catch as e {
        MsgBox("Σφάλμα κατά τη φόρτωση INI: " e.Message, "Σφάλμα", 0x10)
    }
}


GetExpenseTotal(category) {
    global Expenses
    total := 0
    for id, expense in Expenses {
        if expense.category = category
            total += Number(expense.amount)
    }
    return total
}

; Ενημέρωση λίστας χρεών - ΜΟΝΟ ΧΡΕΩΣΤΕΣ
UpdateApartmentDebtsLV() {
    global LVApartmentDebts, ApartmentDebts, Apartments, PreviousPeriodDebts
    
    LVApartmentDebts.Delete()
    
    for apartment, data in Apartments {
        currentDebt := ApartmentDebts.Has(apartment) ? ApartmentDebts[apartment] : 0
        previousDebt := PreviousPeriodDebts.Has(apartment) ? PreviousPeriodDebts[apartment] : 0
        totalDebt := currentDebt + previousDebt
        
        ; ΚΡΙΣΙΜΟ: Εμφάνιση ΜΟΝΟ αν χρωστάει
        if totalDebt > 0.01 {
            LVApartmentDebts.Add(, apartment, data.owner,
                                Format("{:.2f} €", currentDebt),
                                Format("{:.2f} €", previousDebt),
                                Format("{:.2f} €", totalDebt))
        }
    }
}

; Υπολογισμός ποσοστών
CalculatePercentages(*) {
    global Apartments
    
    if Apartments.Count = 0 {
        MsgBox("Δεν υπάρχουν διαμερίσματα για υπολογισμό!", "Πληροφορία", 0x40)
        return
    }
    
    RecalculateAllPercentages()
    AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
    MsgBox("Τα ποσοστά έκδοσης ενημερώθηκαν!`n`n✓ Αποθηκεύτηκε αυτόματα!", "Επιτυχία", 0x40)
}

; Ορισμός αρχικού υπολοίπου
SetInitialBalance(*) {
    global Treasury
    
    InitialBalanceGui := Gui("+Owner" MyGui.Hwnd, "Ορισμός Αρχικού Υπολοίπου")
    InitialBalanceGui.SetFont("s10", "Segoe UI")
    
    InitialBalanceGui.Add("Text", "x20 y20 w150", "Αρχικό Υπόλοιπο:")
    EditInitialBalance := InitialBalanceGui.Add("Edit", "x180 y20 w150", Format("{:.2f}", Treasury.Balance))
    
    BtnSaveBalance := InitialBalanceGui.Add("Button", "x20 y60 w120 h35", "Αποθήκευση")
    BtnSaveBalance.OnEvent("Click", SaveInitialBalance)
    BtnCancelBalance := InitialBalanceGui.Add("Button", "x150 y60 w120 h35", "Ακύρωση")
    BtnCancelBalance.OnEvent("Click", (*) => InitialBalanceGui.Destroy())
    
    SaveInitialBalance(*) {
        try {
            balance := Number(EditInitialBalance.Value)
            Treasury.Balance := balance
            
transaction := {
    date: A_YYYY "-" A_MM "-" A_DD,
    amount: balance,
    type: "Αρχικό Υπόλοιπο",
    description: "Ορισμός αρχικού υπολοίπου ταμείου",
    apartment: ""
}

; ΚΡΙΣΙΜΟ: Χρησιμοποιούμε το ID που επιστρέφει η SaveTransactionToFile
transactionID := SaveTransactionToFile(transaction)
if transactionID != "" {
    Treasury.Transactions[transactionID] := transaction
}
            AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
            
            UpdateTreasuryDisplay()
            UpdateTransactionsLV()
            InitialBalanceGui.Destroy()
            
            MsgBox("Το αρχικό υπόλοιπο ορίστηκε επιτυχώς!`n`n✓ Αποθηκεύτηκε αυτόματα!", "Επιτυχία", 0x40)
        } catch {
            MsgBox("Το ποσό πρέπει να είναι αριθμός!", "Σφάλμα", 0x10)
        }
    }
    
    InitialBalanceGui.Show("w350 h120")
}

; Προσθήκη χειροκίνητου χρέους
AddManualDebt(*) {
    global ApartmentDebts, Treasury, PreviousPeriodDebts
    
    ManualDebtGui := Gui("+Owner" MyGui.Hwnd, "Προσθήκη Χειροκίνητου Χρέους")
    ManualDebtGui.SetFont("s10", "Segoe UI")
    
    ManualDebtGui.Add("Text", "x20 y20 w100", "Διαμέρισμα:")
    DDApartmentDebt := ManualDebtGui.Add("DropDownList", "x130 y20 w200")
    
    apartmentCount := 0
    for apartment in Apartments {
        DDApartmentDebt.Add([apartment])
        apartmentCount++
    }
    
    if apartmentCount > 0
        DDApartmentDebt.Choose(1)
    
    ManualDebtGui.Add("Text", "x20 y60 w100", "Ποσό Χρέους:")
    EditManualDebt := ManualDebtGui.Add("Edit", "x130 y60 w150", "0.00")
    ManualDebtGui.Add("Text", "x20 y100 w100", "Περιγραφή:")
    EditDebtDesc := ManualDebtGui.Add("Edit", "x130 y100 w200", "Χρέος από προηγούμενη περίοδο")
    
    BtnSaveManualDebt := ManualDebtGui.Add("Button", "x20 y140 w120 h35", "Αποθήκευση")
    BtnSaveManualDebt.OnEvent("Click", SaveManualDebt)
    BtnCancelManualDebt := ManualDebtGui.Add("Button", "x150 y140 w120 h35", "Ακύρωση")
    BtnCancelManualDebt.OnEvent("Click", (*) => ManualDebtGui.Destroy())
    

SaveManualDebt(*) {
    try {
        debtAmount := Number(EditManualDebt.Value)
        if debtAmount <= 0 {
            MsgBox("Το ποσό πρέπει να είναι μεγαλύτερο από 0!", "Σφάλμα", 0x10)
            return
        }
    } catch {
        MsgBox("Το ποσό πρέπει να είναι αριθμός!", "Σφάλμα", 0x10)
        return
    }
    
    if DDApartmentDebt.Text = "" {
        MsgBox("Επιλέξτε διαμέρισμα!", "Σφάλμα", 0x10)
        return
    }
    
    apartment := DDApartmentDebt.Text
    
    ; ΚΡΙΣΙΜΟ: Ενημέρωση PreviousPeriodDebts
    if !PreviousPeriodDebts.Has(apartment) {
        PreviousPeriodDebts[apartment] := 0
    }
    PreviousPeriodDebts[apartment] += debtAmount
    
    ; ΚΡΙΣΙΜΟ: ΔΙΟΡΘΩΣΗ - Χρήση φακέλου περιόδου αντί του φακέλου προγράμματος
    if CurrentPeriod != "" && CurrentPeriodFolder != "" {
        fileName := CurrentPeriodFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") ".ini"
        try {
            IniWrite(Format("{:.2f}", PreviousPeriodDebts[apartment]), fileName, "PreviousDebts", apartment)
        } catch as e {
            MsgBox("Σφάλμα αποθήκευσης: " e.Message, "Σφάλμα", 0x10)
        }
    }
    
    transaction := {
        date: A_YYYY "-" A_MM "-" A_DD,
        amount: 0,
        type: "Χειροκίνητο Χρέος",
        description: EditDebtDesc.Value " - Ποσό: " Format("{:.2f} €", debtAmount),
        apartment: apartment
    }

    ; ΚΡΙΣΙΜΟ: Χρησιμοποιούμε το ID που επιστρέφει η SaveTransactionToFile
    transactionID := SaveTransactionToFile(transaction)
    if transactionID != "" {
        Treasury.Transactions[transactionID] := transaction
    }
    
    ; ΚΡΙΣΙΜΟ: ΑΜΕΣΗ ΑΠΟΘΗΚΕΥΣΗ ΠΕΡΙΟΔΟΥ
    AutoSavePeriod()
    
    UpdateTreasuryDisplay()
    UpdateTransactionsLV()
    UpdateApartmentDebtsLV()
    AutoCalculateDebts()
    
    MsgBox("Το χρέος " Format("{:.2f} €", debtAmount) " προστέθηκε επιτυχώς στο " apartment "!`n`n✓ Αποθηκεύτηκε αυτόματα!", "Επιτυχία", 0x40)
    ManualDebtGui.Destroy()
}
    
    ManualDebtGui.Show("w350 h200")
}

; Ενημέρωση χρεών διαμερισμάτων - ΑΠΕΝΕΡΓΟΠΟΙΗΜΕΝΗ
UpdateApartmentDebts(*) {
    MsgBox("Αυτή η λειτουργία δεν χρειάζεται πλέον!`n`n" .
           "Τα χρέη ενημερώνονται ΑΥΤΟΜΑΤΑ:`n`n" .
           "✓ Όταν προσθέτετε έξοδα`n" .
           "✓ Όταν καταχωρείτε πληρωμές`n" .
           "✓ Όταν διαγράφετε συναλλαγές`n" .
           "✓ Όταν αλλάζετε καρτέλα`n`n" .
           "Δεν χρειάζεται να πατάτε κανένα κουμπί!", "Πληροφορία", 0x40)
}

; Εκκαθάριση χρεών
ClearApartmentDebts(*) {
    global ApartmentDebts, PreviousPeriodDebts, Treasury
    
    if ApartmentDebts.Count = 0 {
        MsgBox("Δεν υπάρχουν χρέη για εκκαθάριση!", "Πληροφορία", 0x40)
        return
    }
    
    if MsgBox("Θέλετε να εκκαθαρίσετε όλα τα χρέη διαμερισμάτων;", "Εκκαθάριση Χρεών", 0x34) = "Yes" {
        ApartmentDebts.Clear()
        PreviousPeriodDebts.Clear()
        Treasury.PreviousDebt := 0
        
        AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
        
        UpdateApartmentDebtsLV()
        UpdateTreasuryDisplay()
        AutoCalculateDebts()
        
        MsgBox("Τα χρέη εκκαθαρίστηκαν επιτυχώς!`n`n✓ Αποθηκεύτηκε αυτόματα!", "Επιτυχία", 0x40)
    }
}

; Αποθήκευση δεδομένων ταμείου
SaveTreasuryData(*) {
    global Treasury, CurrentPeriod, ApartmentDebts, PreviousPeriodDebts, CurrentPeriodFolder
    
    if CurrentPeriod = "" || CurrentPeriodFolder = "" {
        MsgBox("Δεν έχει οριστεί περίοδος!", "Σφάλμα", 0x10)
        return
    }
    
    fileName := CurrentPeriodFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_Cash.ini"
    
    try {
        if FileExist(fileName)
            FileDelete(fileName)
        
        IniWrite(Treasury.Balance, fileName, "Treasury", "Balance")
        IniWrite(Treasury.PreviousDebt, fileName, "Treasury", "PreviousDebt")
        IniWrite(Treasury.TotalIncome, fileName, "Treasury", "TotalIncome")
        IniWrite(Treasury.TotalExpenses, fileName, "Treasury", "TotalExpenses")
        
        for apartment, debt in ApartmentDebts {
            if debt > 0.01 {
                IniWrite(Format("{:.2f}", debt), fileName, "CurrentDebts", apartment)
            }
        }
        
        for apartment, debt in PreviousPeriodDebts {
            if debt > 0.01 {
                IniWrite(Format("{:.2f}", debt), fileName, "PreviousDebts", apartment)
            }
        }
        
        transactionCount := 0
        for id, transaction in Treasury.Transactions {
            transactionCount++
            IniWrite(transaction.date, fileName, id, "Date")
            IniWrite(transaction.amount, fileName, id, "Amount")
            IniWrite(transaction.type, fileName, id, "Type")
            IniWrite(transaction.description, fileName, id, "Description")
            IniWrite(transaction.apartment, fileName, id, "Apartment")
        }
        
        IniWrite(transactionCount, fileName, "TreasuryInfo", "TransactionCount")
        IniWrite(A_Now, fileName, "TreasuryInfo", "LastSaved")
        IniWrite(CurrentPeriod, fileName, "TreasuryInfo", "Period")
        
        MsgBox("Τα δεδομένα ταμείου αποθηκεύτηκαν επιτυχώς!`n`nΑρχείο: " fileName "`nΣυναλλαγές: " transactionCount "`nΥπόλοιπο: " Format("{:.2f} €", Treasury.Balance) "`nΧρέη: " Format("{:.2f} €", Treasury.PreviousDebt), "Επιτυχία", 0x40)
    } catch as e {
        MsgBox("Σφάλμα κατά την αποθήκευση ταμείου: " e.Message, "Σφάλμα", 0x10)
    }
}

; Δημιουργία αρχείου περιόδου
CreatePeriodFile() {
    global CurrentPeriod, CurrentPeriodFolder
    if CurrentPeriod = "" || CurrentPeriodFolder = ""
        return
    
    ; Αλλαγή εδώ: Χρήση φακέλου περιόδου
    fileName := CurrentPeriodFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") ".ini"
    
    try {
        if !FileExist(fileName) {
            FileAppend("", fileName)
            IniWrite(CurrentPeriod, fileName, "PeriodInfo", "Name")
            IniWrite(A_Now, fileName, "PeriodInfo", "Created")
        }
    } catch as e {
        MsgBox("Σφάλμα κατά τη δημιουργία αρχείου περιόδου: " e.Message, "Σφάλμα", 0x10)
    }
}

; Δημιουργία αρχείου κινήσεων
CreateTransactionsFile() {
    global CurrentPeriod, CurrentPeriodFolder
    if CurrentPeriod = "" || CurrentPeriodFolder = ""
        return
    
    ; Αλλαγή εδώ: Χρήση φακέλου περιόδου
    fileName := CurrentPeriodFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_Transactions.ini"
    
    try {
        if !FileExist(fileName) {
            FileAppend("", fileName)
            IniWrite(CurrentPeriod, fileName, "TransactionsInfo", "Period")
            IniWrite(A_Now, fileName, "TransactionsInfo", "Created")
        }
    }
}

; Αποθήκευση συναλλαγής - ΔΙΟΡΘΩΜΕΝΗ
SaveTransactionToFile(transaction) {
    global CurrentPeriod, CurrentPeriodFolder
    if CurrentPeriod = "" || CurrentPeriodFolder = ""
        return ""
    
    ; Αλλαγή εδώ: Χρήση φακέλου περιόδου
    fileName := CurrentPeriodFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_Transactions.ini"
    
    try {
        transactionID := "Transaction_" A_Now
        IniWrite(transaction.date, fileName, transactionID, "Date")
        IniWrite(transaction.amount, fileName, transactionID, "Amount")
        IniWrite(transaction.type, fileName, transactionID, "Type")
        IniWrite(transaction.description, fileName, transactionID, "Description")
        IniWrite(transaction.apartment, fileName, transactionID, "Apartment")
        
        ; Αποθηκεύουμε και την ανάλυση πληρωμής
        if transaction.HasOwnProp("paidCurrentDebt") {
            IniWrite(transaction.paidCurrentDebt, fileName, transactionID, "PaidCurrentDebt")
        }
        if transaction.HasOwnProp("paidPreviousDebt") {
            IniWrite(transaction.paidPreviousDebt, fileName, transactionID, "PaidPreviousDebt")
        }
        
        ; ΚΡΙΣΙΜΟ: Επιστρέφουμε το ID
        return transactionID
    }
    return ""
}

; Ενημέρωση συνόλων
UpdateTotals() {
    global
    TotalCommon := 0, TotalElevator := 0, TotalHeating := 0, TotalPercentage := 0
    
    for apartment, data in Apartments {
        TotalCommon += Number(data.common)
        TotalElevator += Number(data.elevator)
        TotalHeating += Number(data.heating)
        TotalPercentage += Number(data.percentage)
    }
    
    TotalCommonText.Text := Format("{:.2f}", TotalCommon)
    TotalElevatorText.Text := Format("{:.2f}", TotalElevator)
    TotalHeatingText.Text := Format("{:.2f}", TotalHeating)
    TotalPercentageText.Text := Format("{:.2f}", TotalPercentage) " %"
    
    LVTotalCommon.Text := Format("{:.2f}", TotalCommon)
    LVTotalElevator.Text := Format("{:.2f}", TotalElevator)
    LVTotalHeating.Text := Format("{:.2f}", TotalHeating)
    LVTotalPercentage.Text := Format("{:.2f}", TotalPercentage) " %"
    
    if Abs(TotalCommon - 1000) > 0.01
        TotalCommonText.SetFont("s10 Bold", "CC0000")
    else
        TotalCommonText.SetFont("s10 Bold", "006600")
    
    if Abs(TotalElevator - 1000) > 0.01
        TotalElevatorText.SetFont("s10 Bold", "CC0000")
    else
        TotalElevatorText.SetFont("s10 Bold", "006600")
    
    if Abs(TotalHeating - 1000) > 0.01
        TotalHeatingText.SetFont("s10 Bold", "CC0000")
    else
        TotalHeatingText.SetFont("s10 Bold", "006600")
    
    if Abs(TotalPercentage - 100) > 0.01
        TotalPercentageText.SetFont("s10 Bold", "CC0000")
    else
        TotalPercentageText.SetFont("s10 Bold", "006600")
}

; Διπλό κλικ στη λίστα εξόδων
LVExpenses_DoubleClick(LV, Row) {
    global
    if Row = 0
        return
    
    EditExpense()
}

; Επεξεργασία εξόδου
EditExpense(*) {
    global LVExpenses, Expenses
    
    Row := LVExpenses.GetNext()
    if Row = 0 {
        MsgBox("Επιλέξτε ένα έξοδο για επεξεργασία!", "Πληροφορία", 0x40)
        return
    }
    
    selectedDate := LVExpenses.GetText(Row, 1)
    selectedAmount := StrReplace(LVExpenses.GetText(Row, 2), " €", "")
    selectedCategory := LVExpenses.GetText(Row, 3)
    
    foundExpenseID := ""
    for id, expense in Expenses {
        if expense.date = selectedDate && Format("{:.2f}", expense.amount) = selectedAmount && expense.category = selectedCategory {
            foundExpenseID := id
            break
        }
    }
    
    if foundExpenseID = "" {
        MsgBox("Δεν βρέθηκε το έξοδο!", "Σφάλμα", 0x10)
        return
    }
    
    expenseData := Expenses[foundExpenseID]
    
    EditExpenseGui := Gui("+Owner" MyGui.Hwnd, "Επεξεργασία Εξόδου")
    EditExpenseGui.SetFont("s10", "Segoe UI")
    
    EditExpenseGui.Add("Text", "x20 y20 w100", "Ημερομηνία:")
    EditExpDate := EditExpenseGui.Add("Edit", "x130 y20 w150", expenseData.date)
    EditExpenseGui.Add("Text", "x20 y60 w100", "Ποσό:")
    EditExpAmount := EditExpenseGui.Add("Edit", "x130 y60 w150", Format("{:.2f}", expenseData.amount))
    EditExpenseGui.Add("Text", "x20 y100 w100", "Κατηγορία:")
    EditExpCategory := EditExpenseGui.Add("DropDownList", "x130 y100 w200", ExpenseCategories)
    EditExpCategory.Text := expenseData.category
    EditExpenseGui.Add("Text", "x20 y140 w100", "Είδος:")
    EditExpType := EditExpenseGui.Add("DropDownList", "x130 y140 w200", [])
    EditExpenseGui.Add("Text", "x20 y180 w100", "Περιγραφή:")
    EditExpDesc := EditExpenseGui.Add("Edit", "x130 y180 w300 h80", expenseData.description)
    
    UpdateExpenseTypes(category) {
        EditExpType.Delete()
        if ExpenseTypes.Has(category) {
            for index, expenseType in ExpenseTypes[category] {
                EditExpType.Add([expenseType])
            }
        }
        EditExpType.Text := expenseData.type
    }
    
    UpdateExpenseTypes(expenseData.category)
    EditExpCategory.OnEvent("Change", (*) => UpdateExpenseTypes(EditExpCategory.Text))
    
    BtnSaveEdit := EditExpenseGui.Add("Button", "x130 y280 w120 h35", "Αποθήκευση")
    BtnSaveEdit.OnEvent("Click", SaveEditedExpense)
    BtnCancelEdit := EditExpenseGui.Add("Button", "x260 y280 w120 h35", "Ακύρωση")
    BtnCancelEdit.OnEvent("Click", (*) => EditExpenseGui.Destroy())
    
    SaveEditedExpense(*) {
        try {
            newAmount := Number(EditExpAmount.Value)
            if newAmount <= 0 {
                MsgBox("Το ποσό πρέπει να είναι μεγαλύτερο από 0!", "Σφάλμα", 0x10)
                return
            }
        } catch {
            MsgBox("Το ποσό πρέπει να είναι αριθμός!", "Σφάλμα", 0x10)
            return
        }
        
        oldAmount := expenseData.amount

    if EditExpCategory.Text != "Αποθεματικό" {
        Treasury.Balance += oldAmount      
        Treasury.TotalExpenses -= oldAmount
        Treasury.Balance -= newAmount      
        Treasury.TotalExpenses += newAmount
    }
        
        Expenses[foundExpenseID] := {
            date: EditExpDate.Value,
            amount: newAmount,
            category: EditExpCategory.Text,
            type: EditExpType.Text,
            description: EditExpDesc.Value
        }
        
        for id, transaction in Treasury.Transactions {
            if transaction.type = "Έξοδο" && Abs(transaction.amount) = oldAmount {
                Treasury.Transactions[id].amount := -newAmount
                Treasury.Transactions[id].description := EditExpCategory.Text " - " EditExpType.Text
                break
            }
        }
        
        AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
        
        UpdateExpenseLV()
        UpdateExpenseTotals()
        UpdateTreasuryDisplay()
        UpdateTransactionsLV()
        AutoCalculateDebts()
        
        EditExpenseGui.Destroy()
        MsgBox("Το έξοδο ενημερώθηκε επιτυχώς!`n`n✓ Αποθηκεύτηκε αυτόματα!", "Επιτυχία", 0x40)
    }
    
    EditExpenseGui.Show("w450 h350")
}

DeleteExpense(*) {
    global LVExpenses, Expenses, Treasury, CurrentPeriod
    
    Row := LVExpenses.GetNext()
    if Row = 0 {
        MsgBox("Επιλέξτε ένα έξοδο για διαγραφή!", "Πληροφορία", 0x40)
        return
    }
    
    selectedDate := LVExpenses.GetText(Row, 1)
    selectedAmount := StrReplace(LVExpenses.GetText(Row, 2), " €", "")
    selectedCategory := LVExpenses.GetText(Row, 3)
    
    foundExpenseID := ""
    for id, expense in Expenses {
        if expense.date = selectedDate && Format("{:.2f}", expense.amount) = selectedAmount && expense.category = selectedCategory {
            foundExpenseID := id
            break
        }
    }
    
    if foundExpenseID = "" {
        MsgBox("Δεν βρέθηκε το έξοδο!", "Σφάλμα", 0x10)
        return
    }
    
    expenseAmount := Expenses[foundExpenseID].amount
    
    if MsgBox("Θέλετε να διαγράψετε αυτό το έξοδο;`nΠοσό: " Format("{:.2f} €", expenseAmount) "`nΚατηγορία: " selectedCategory, "Διαγραφή Εξόδου", 0x34) = "Yes" {
        ; Ενημέρωση ταμείου
        if selectedCategory != "Αποθεματικό" {
            Treasury.Balance += expenseAmount
            Treasury.TotalExpenses -= expenseAmount
        }
        
        ; Διαγραφή από τη μνήμη
        Expenses.Delete(foundExpenseID)
        
        ; Εύρεση και διαγραφή συναλλαγής
        transactionToDelete := ""
        for id, transaction in Treasury.Transactions {
            if transaction.type = "Έξοδο" && Abs(transaction.amount) = expenseAmount {
                transactionToDelete := id
                break
            }
        }
        
        if transactionToDelete != "" {
            Treasury.Transactions.Delete(transactionToDelete)
            
            if CurrentPeriod != "" {
                transactionsFile := RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_Transactions.ini"
                if FileExist(transactionsFile) {
                    try {
                        IniDelete(transactionsFile, transactionToDelete)
                    } catch as e {
                        MsgBox("Προειδοποίηση: Δεν ήταν δυνατή η διαγραφή της συναλλαγής από το αρχείο.`n`nΣφάλμα: " e.Message, "Προειδοποίηση", 0x30)
                    }
                }
            }
        }
        
        AutoSavePeriod()
        
        ; Ενημέρωση λιστών Tab 1
        UpdateExpenseLV()
        UpdateExpenseTotals()
        UpdateTreasuryDisplay()
        UpdateTransactionsLV()
        
        ; ═══════════════════════════════════════════════════════════
        ; ΚΡΙΣΙΜΟ: Ενημέρωση ΚΑΙ ΤΩΝ ΔΥΟ TABS
        ; ═══════════════════════════════════════════════════════════
        AutoCalculateDebts()         ; Ενημερώνει Tab 4 (LVDebts)
        UpdateApartmentDebtsLV()     ; Ενημερώνει Tab 5 (LVApartmentDebts)
        
        MsgBox("Το έξοδο διαγράφηκε επιτυχώς!`n`nΤο ταμείο ενημερώθηκε: +" Format("{:.2f} €", expenseAmount) "`n`n✓ Αποθηκεύτηκε αυτόματα!`n✓ Οι οφειλές ενημερώθηκαν!`n✓ Tab 4 & Tab 5 ενημερώθηκαν!", "Επιτυχία", 0x40)
    }
}


; Διπλό κλικ στη λίστα συναλλαγών
LVTransactions_DoubleClick(LV, Row) {
    global
    if Row = 0
        return
    
    EditTransaction()
}

; Επεξεργασία συναλλαγής
EditTransaction(*) {
    global LVTransactions, Treasury
    
    Row := LVTransactions.GetNext()
    if Row = 0 {
        MsgBox("Επιλέξτε μια συναλλαγή για επεξεργασία!", "Πληροφορία", 0x40)
        return
    }
    
    selectedDate := LVTransactions.GetText(Row, 1)
    selectedAmount := StrReplace(LVTransactions.GetText(Row, 2), " €", "")
    selectedType := LVTransactions.GetText(Row, 3)
    
    foundTransactionID := ""
    for id, transaction in Treasury.Transactions {
        if transaction.date = selectedDate && Format("{:.2f}", transaction.amount) = selectedAmount && transaction.type = selectedType {
            foundTransactionID := id
            break
        }
    }
    
    if foundTransactionID = "" {
        MsgBox("Δεν βρέθηκε η συναλλαγή!", "Σφάλμα", 0x10)
        return
    }
    
    transactionData := Treasury.Transactions[foundTransactionID]
    
    EditTransGui := Gui("+Owner" MyGui.Hwnd, "Επεξεργασία Συναλλαγής")
    EditTransGui.SetFont("s10", "Segoe UI")
    
    EditTransGui.Add("Text", "x20 y20 w100", "Ημερομηνία:")
    EditTransDate := EditTransGui.Add("Edit", "x130 y20 w150", transactionData.date)
    EditTransGui.Add("Text", "x20 y60 w100", "Ποσό:")
    EditTransAmount := EditTransGui.Add("Edit", "x130 y60 w150", Format("{:.2f}", Abs(transactionData.amount)))
    EditTransGui.Add("Text", "x20 y100 w100", "Τύπος:")
    EditTransType := EditTransGui.Add("DropDownList", "x130 y100 w200", ["Είσπραξη", "Έξοδο", "Αρχικό Υπόλοιπο", "Χειροκίνητο Χρέος"])
    EditTransType.Text := transactionData.type
    EditTransGui.Add("Text", "x20 y140 w100", "Περιγραφή:")
    EditTransDesc := EditTransGui.Add("Edit", "x130 y140 w300 h60", transactionData.description)
    EditTransGui.Add("Text", "x20 y210 w100", "Διαμέρισμα:")
    EditTransApartment := EditTransGui.Add("Edit", "x130 y210 w200", transactionData.apartment)
    
    BtnSaveTransEdit := EditTransGui.Add("Button", "x130 y250 w120 h35", "Αποθήκευση")
    BtnSaveTransEdit.OnEvent("Click", SaveEditedTransaction)
    BtnCancelTransEdit := EditTransGui.Add("Button", "x260 y250 w120 h35", "Ακύρωση")
    BtnCancelTransEdit.OnEvent("Click", (*) => EditTransGui.Destroy())
    
    SaveEditedTransaction(*) {
        try {
            newAmount := Number(EditTransAmount.Value)
            if newAmount <= 0 {
                MsgBox("Το ποσό πρέπει να είναι μεγαλύτερο από 0!", "Σφάλμα", 0x10)
                return
            }
        } catch {
            MsgBox("Το ποσό πρέπει να είναι αριθμός!", "Σφάλμα", 0x10)
            return
        }
        
        newType := EditTransType.Text
        
        oldAmount := transactionData.amount
        if transactionData.type = "Είσπραξη" || transactionData.type = "Αρχικό Υπόλοιπο" {
            Treasury.Balance -= oldAmount
            Treasury.TotalIncome -= oldAmount
        } else if transactionData.type = "Έξοδο" {
            Treasury.Balance -= oldAmount
            Treasury.TotalExpenses += oldAmount
        }
        
        if newType = "Είσπραξη" || newType = "Αρχικό Υπόλοιπο" {
            Treasury.Balance += newAmount
            Treasury.TotalIncome += newAmount
            Treasury.Transactions[foundTransactionID].amount := newAmount
        } else if newType = "Έξοδο" {
            Treasury.Balance -= newAmount
            Treasury.TotalExpenses += newAmount
            Treasury.Transactions[foundTransactionID].amount := -newAmount
        } else {
            Treasury.Transactions[foundTransactionID].amount := 0
        }
        
        Treasury.Transactions[foundTransactionID].date := EditTransDate.Value
        Treasury.Transactions[foundTransactionID].type := newType
        Treasury.Transactions[foundTransactionID].description := EditTransDesc.Value
        Treasury.Transactions[foundTransactionID].apartment := EditTransApartment.Value
        
        AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
        
        UpdateTransactionsLV()
        UpdateTreasuryDisplay()
        
        EditTransGui.Destroy()
        MsgBox("Η συναλλαγή ενημερώθηκε επιτυχώς!`n`n✓ Αποθηκεύτηκε αυτόματα!", "Επιτυχία", 0x40)
    }
    
    EditTransGui.Show("w450 h320")
}


; Διαγραφή συναλλαγής - ΔΙΟΡΘΩΜΕΝΗ ΜΕ ΔΙΑΓΡΑΦΗ ΑΠΟ ΑΡΧΕΙΟ
DeleteTransaction(*) {
    global LVTransactions, Treasury, ApartmentDebts, PreviousPeriodDebts, ApartmentPayments, CurrentPeriod
    
    Row := LVTransactions.GetNext()
    if Row = 0 {
        MsgBox("Επιλέξτε μια συναλλαγή για διαγραφή!", "Πληροφορία", 0x40)
        return
    }
    
    selectedDate := LVTransactions.GetText(Row, 1)
    selectedAmount := StrReplace(LVTransactions.GetText(Row, 2), " €", "")
    selectedType := LVTransactions.GetText(Row, 3)
    selectedApartment := LVTransactions.GetText(Row, 5)
    
    foundTransactionID := ""
    for id, transaction in Treasury.Transactions {
        if transaction.date = selectedDate && Format("{:.2f}", Abs(transaction.amount)) = selectedAmount && transaction.type = selectedType {
            foundTransactionID := id
            break
        }
    }
    
    if foundTransactionID = "" {
        MsgBox("Δεν βρέθηκε η συναλλαγή!", "Σφάλμα", 0x10)
        return
    }
    
    transactionAmount := Treasury.Transactions[foundTransactionID].amount
    transactionType := Treasury.Transactions[foundTransactionID].type
    transactionApartment := Treasury.Transactions[foundTransactionID].apartment
    transactionDesc := Treasury.Transactions[foundTransactionID].description

    ; Ανακτούμε την ανάλυση πληρωμής
    paidCurrentDebt := 0
    paidPreviousDebt := 0
    
    if Treasury.Transactions[foundTransactionID].HasOwnProp("paidCurrentDebt") {
        paidCurrentDebt := Treasury.Transactions[foundTransactionID].paidCurrentDebt
    }
    if Treasury.Transactions[foundTransactionID].HasOwnProp("paidPreviousDebt") {
        paidPreviousDebt := Treasury.Transactions[foundTransactionID].paidPreviousDebt
    }
    
    ; Εξαγωγή ποσού από την περιγραφή για χειροκίνητα χρέη
    manualDebtAmount := 0
    if transactionType = "Χειροκίνητο Χρέος" && InStr(transactionDesc, "Ποσό:") {
        try {
            debtPart := SubStr(transactionDesc, InStr(transactionDesc, "Ποσό:") + 6)
            debtPart := StrReplace(debtPart, " €", "")
            debtPart := StrReplace(debtPart, ",", ".")
            debtPart := Trim(debtPart)
            manualDebtAmount := Number(debtPart)
        }
    }
    
    warningMsg := "Θέλετε να διαγράψετε αυτή τη συναλλαγή;`n`n"
    
    ; Διαφορετική προειδοποίηση για κάθε τύπο
    if transactionType = "Αρχικό Υπόλοιπο" {
        warningMsg .= "Τύπος: " transactionType "`nΠοσό: " Format("{:.2f} €", Abs(transactionAmount))
        warningMsg .= "`n`nΠΡΟΣΟΧΗ: Θα αφαιρεθεί από τα ΜΕΤΡΗΤΑ μόνο, όχι από τις Εισπράξεις!"
    }
    else if transactionType = "Χειροκίνητο Χρέος" {
        warningMsg .= "Διαμέρισμα: " transactionApartment
        warningMsg .= "`nΤύπος: " transactionType
        warningMsg .= "`nΧρέος: " Format("{:.2f} €", manualDebtAmount)
        warningMsg .= "`n`nΠΡΟΣΟΧΗ: Το χρέος θα αφαιρεθεί από το διαμέρισμα!"
    }
    else if (transactionType = "Είσπραξη" || transactionType = "Πληρωμή") {
        warningMsg .= "Διαμέρισμα: " transactionApartment
        warningMsg .= "`nΤύπος: " transactionType
        warningMsg .= "`nΠοσό: " Format("{:.2f} €", Abs(transactionAmount))
        if paidCurrentDebt > 0 || paidPreviousDebt > 0 {
            warningMsg .= "`n`nΕπιστροφή χρέους:"
            if paidCurrentDebt > 0
                warningMsg .= "`n  • Περιόδου: " Format("{:.2f} €", paidCurrentDebt)
            if paidPreviousDebt > 0
                warningMsg .= "`n  • Προηγούμενης: " Format("{:.2f} €", paidPreviousDebt)
        } else {
            warningMsg .= "`n`nΠΡΟΣΟΧΗ: Το χρέος θα επανεμφανιστεί!"
        }
    }
    else {
        warningMsg .= "Τύπος: " transactionType
        warningMsg .= "`nΠοσό: " Format("{:.2f} €", Abs(transactionAmount))
    }
    
    if MsgBox(warningMsg, "Διαγραφή Συναλλαγής", 0x34) = "Yes" {
        
        ; Χειρισμός χειροκίνητου χρέους
        if transactionType = "Χειροκίνητο Χρέος" && transactionApartment != "" && manualDebtAmount > 0 {
            if PreviousPeriodDebts.Has(transactionApartment) {
                PreviousPeriodDebts[transactionApartment] -= manualDebtAmount
                if PreviousPeriodDebts[transactionApartment] < 0.01 {
                    PreviousPeriodDebts.Delete(transactionApartment)
                }
            }
        }
        ; Χειρισμός πληρωμής/είσπραξης
        else if (transactionType = "Είσπραξη" || transactionType = "Πληρωμή") && transactionApartment != "" {
            
            if ApartmentPayments.Has(transactionApartment) {
                ApartmentPayments[transactionApartment] -= Abs(transactionAmount)
                if ApartmentPayments[transactionApartment] < 0.01 {
                    ApartmentPayments.Delete(transactionApartment)
                }
            }
            
            ; Χρησιμοποιούμε την αποθηκευμένη ανάλυση
            if paidCurrentDebt > 0 {
                if ApartmentDebts.Has(transactionApartment) {
                    ApartmentDebts[transactionApartment] += paidCurrentDebt
                } else {
                    ApartmentDebts[transactionApartment] := paidCurrentDebt
                }
            }
            
            if paidPreviousDebt > 0 {
                if PreviousPeriodDebts.Has(transactionApartment) {
                    PreviousPeriodDebts[transactionApartment] += paidPreviousDebt
                } else {
                    PreviousPeriodDebts[transactionApartment] := paidPreviousDebt
                }
            }
            
            ; FALLBACK για παλιές πληρωμές χωρίς ανάλυση
            if paidCurrentDebt = 0 && paidPreviousDebt = 0 {
                if PreviousPeriodDebts.Has(transactionApartment) {
                    PreviousPeriodDebts[transactionApartment] += Abs(transactionAmount)
                } else {
                    if ApartmentDebts.Has(transactionApartment) {
                        ApartmentDebts[transactionApartment] += Abs(transactionAmount)
                    } else {
                        ApartmentDebts[transactionApartment] := Abs(transactionAmount)
                    }
                }
            }
        }
        
        ; Ενημέρωση ταμείου με διαχωρισμό Αρχικού Υπολοίπου
        if transactionType = "Αρχικό Υπόλοιπο" {
            Treasury.Balance -= transactionAmount
        }
        else if transactionType = "Είσπραξη" {
            Treasury.Balance -= transactionAmount
            Treasury.TotalIncome -= transactionAmount
        }
        else if transactionType = "Έξοδο" {
            Treasury.Balance -= transactionAmount
            Treasury.TotalExpenses += transactionAmount
        }
        
        ; ═══════════════════════════════════════════════════════════
        ; ΚΡΙΣΙΜΟ: Διαγραφή από τη μνήμη
        ; ═══════════════════════════════════════════════════════════
        Treasury.Transactions.Delete(foundTransactionID)
        
        ; ═══════════════════════════════════════════════════════════
        ; ΚΡΙΣΙΜΟ: Διαγραφή από το αρχείο _Transactions.ini
        ; ═══════════════════════════════════════════════════════════
if CurrentPeriod != "" && CurrentPeriodFolder != "" {
    ; Αλλαγή εδώ: Χρήση φακέλου περιόδου
    transactionsFile := CurrentPeriodFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_Transactions.ini"
    
    if FileExist(transactionsFile) {
        try {
            ; Διαγραφή του section από το INI αρχείο
            IniDelete(transactionsFile, foundTransactionID)
        } catch as e {
            MsgBox("Προειδοποίηση: Δεν ήταν δυνατή η διαγραφή από το αρχείο.`n`nΣφάλμα: " e.Message, "Προειδοποίηση", 0x30)
        }
    }
}
        
        AutoSavePeriod()
        
        UpdateTransactionsLV()
        UpdateTreasuryDisplay()
        AutoCalculateDebts()
        UpdateApartmentDebtsLV()
        
        successMsg := "Η συναλλαγή διαγράφηκε επιτυχώς!`n`n"
        
        if transactionType = "Αρχικό Υπόλοιπο" {
            successMsg .= "Το ποσό " Format("{:.2f} €", Abs(transactionAmount)) " αφαιρέθηκε από τα Μετρητά.`n"
            successMsg .= "Οι Εισπράξεις παραμένουν αμετάβλητες.`n`n"
        }
        else if transactionType = "Χειροκίνητο Χρέος" && transactionApartment != "" {
            successMsg .= "Το χρέος " Format("{:.2f} €", manualDebtAmount) " αφαιρέθηκε από το " transactionApartment "!`n`n"
        }
        else if transactionApartment != "" && (paidCurrentDebt > 0 || paidPreviousDebt > 0) {
            successMsg .= "Επαναφέρθηκαν χρέη στο " transactionApartment ":`n"
            if paidCurrentDebt > 0
                successMsg .= "  • Περιόδου: " Format("{:.2f} €", paidCurrentDebt) "`n"
            if paidPreviousDebt > 0
                successMsg .= "  • Προηγούμενης: " Format("{:.2f} €", paidPreviousDebt) "`n"
            successMsg .= "`n"
        }
        else if transactionApartment != "" {
            successMsg .= "Το χρέος του " transactionApartment " επανήλθε!`n`n"
        }
        
        successMsg .= "✓ Αποθηκεύτηκε αυτόματα!"
        successMsg .= "`n✓ Διαγράφηκε ΜΟΝΙΜΑ από το αρχείο!"
        
        MsgBox(successMsg, "Επιτυχία", 0x40)
    }
}


; Διπλό κλικ στη λίστα χρεών για γρήγορη πληρωμή
LVApartmentDebts_DoubleClick(LV, Row) {
    global
    if Row = 0
        return
    
    apartment := LV.GetText(Row, 1)
    totalDebtStr := LV.GetText(Row, 5)
    totalDebt := Number(StrReplace(StrReplace(totalDebtStr, " €", ""), ",", "."))
    
    QuickPaymentGui := Gui("+Owner" MyGui.Hwnd, "Πληρωμή - " apartment)
    QuickPaymentGui.SetFont("s10", "Segoe UI")
    
    QuickPaymentGui.Add("Text", "x20 y20 w150", "Διαμέρισμα:")
    QuickPaymentGui.Add("Text", "x180 y20 w200", apartment).SetFont("s10 Bold")
    
    QuickPaymentGui.Add("Text", "x20 y50 w150", "Συνολικό Χρέος:")
    QuickPaymentGui.Add("Text", "x180 y50 w200", Format("{:.2f} €", totalDebt)).SetFont("s10 Bold", "CC0000")
    
    QuickPaymentGui.Add("Text", "x20 y90 w150", "Ποσό Πληρωμής:")
    EditQuickPayment := QuickPaymentGui.Add("Edit", "x180 y90 w200", Format("{:.2f}", totalDebt))
    
    QuickPaymentGui.Add("Text", "x20 y130 w150", "Ημερομηνία:")
    EditQuickPaymentDate := QuickPaymentGui.Add("Edit", "x180 y130 w200", A_DD "/" A_MM "/" A_YYYY)
    
    QuickPaymentGui.Add("Text", "x20 y170 w150", "Περιγραφή:")
    EditQuickPaymentDesc := QuickPaymentGui.Add("Edit", "x180 y170 w200", "Εξόφληση οφειλής")
    
    BtnFullPayment := QuickPaymentGui.Add("Button", "x20 y220 w180 h35", "Πλήρης Εξόφληση")
    BtnFullPayment.OnEvent("Click", ProcessFullPayment)
    BtnFullPayment.SetFont("s10 Bold")
    
    BtnPartialPayment := QuickPaymentGui.Add("Button", "x210 y220 w170 h35", "Μερική Πληρωμή")
    BtnPartialPayment.OnEvent("Click", ProcessPartialPayment)
    
    BtnCancelQuickPayment := QuickPaymentGui.Add("Button", "x20 y265 w360 h30", "Ακύρωση")
    BtnCancelQuickPayment.OnEvent("Click", (*) => QuickPaymentGui.Destroy())
    
    ProcessFullPayment(*) {
        EditQuickPayment.Value := Format("{:.2f}", totalDebt)
        ProcessPartialPayment()
    }
    
ProcessPartialPayment(*) {
        amountStr := EditQuickPayment.Value
        date := EditQuickPaymentDate.Value
        description := EditQuickPaymentDesc.Value
        
        if amountStr = "" || date = "" {
            MsgBox("Συμπληρώστε όλα τα πεδία!", "Σφάλμα", 0x10)
            return
        }
        
        amount := Number(StrReplace(amountStr, ",", "."))
        
        if amount <= 0 {
            MsgBox("Το ποσό πρέπει να είναι θετικό!", "Σφάλμα", 0x10)
            return
        }
        
        if amount > totalDebt {
            if MsgBox("Το ποσό υπερβαίνει το χρέος (" Format("{:.2f} €", totalDebt) ").`nΘέλετε να συνεχίσετε;", "Προειδοποίηση", 0x34) = "No"
                return
        }
        
        ; ΚΡΙΣΙΜΟ: Αποθηκεύουμε πόσα πήγαν σε κάθε χρέος
        paidCurrentDebt := 0
        paidPreviousDebt := 0
        
        remainingAmount := amount
        
currentDebt := ApartmentDebts.Has(apartment) ? ApartmentDebts[apartment] : 0
        if currentDebt > 0 {
            if currentDebt >= remainingAmount {
                paidCurrentDebt := remainingAmount
                if !ApartmentPayments.Has(apartment)
                    ApartmentPayments[apartment] := 0
                ApartmentPayments[apartment] += remainingAmount
                ApartmentDebts[apartment] -= remainingAmount
                remainingAmount := 0
            } else {
                paidCurrentDebt := currentDebt
                if !ApartmentPayments.Has(apartment)
                    ApartmentPayments[apartment] := 0
                ApartmentPayments[apartment] += currentDebt
                remainingAmount -= currentDebt
                ApartmentDebts[apartment] := 0
            }
        }
        
        if remainingAmount > 0 && PreviousPeriodDebts.Has(apartment) && PreviousPeriodDebts[apartment] > 0 {
            if PreviousPeriodDebts[apartment] >= remainingAmount {
                paidPreviousDebt := remainingAmount
                PreviousPeriodDebts[apartment] -= remainingAmount
                Treasury.PreviousDebt -= remainingAmount
                remainingAmount := 0
            } else {
                paidPreviousDebt := PreviousPeriodDebts[apartment]
                Treasury.PreviousDebt -= PreviousPeriodDebts[apartment]
                remainingAmount -= PreviousPeriodDebts[apartment]
                PreviousPeriodDebts[apartment] := 0
            }
        }
        
        if ApartmentDebts.Has(apartment) && ApartmentDebts[apartment] < 0.01
            ApartmentDebts[apartment] := 0
        if PreviousPeriodDebts.Has(apartment) && PreviousPeriodDebts[apartment] < 0.01
            PreviousPeriodDebts[apartment] := 0
        
        ; ΚΡΙΣΙΜΟ: Αποθηκεύουμε την ανάλυση της πληρωμής
        transaction := {
            date: date,
            amount: amount,
            type: "Είσπραξη",
            description: description,
            apartment: apartment,
            paidCurrentDebt: paidCurrentDebt,
            paidPreviousDebt: paidPreviousDebt
        }
        
Treasury.Balance += amount
Treasury.TotalIncome += amount

; ΚΡΙΣΙΜΟ: Χρησιμοποιούμε το ID που επιστρέφει η SaveTransactionToFile
transactionID := SaveTransactionToFile(transaction)
if transactionID != "" {
    Treasury.Transactions[transactionID] := transaction
}


        AutoSavePeriod()  ; ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
        
        UpdateTreasuryDisplay()
        UpdateTransactionsLV()
        AutoCalculateDebts()  
        UpdateApartmentDebtsLV()  
        
        QuickPaymentGui.Destroy()
        
        currentDebt := ApartmentDebts.Has(apartment) ? ApartmentDebts[apartment] : 0
        previousDebt := PreviousPeriodDebts.Has(apartment) ? PreviousPeriodDebts[apartment] : 0
        
        if currentDebt < 0.01 && previousDebt < 0.01 {
            MsgBox("✓ ΠΛΗΡΗΣ ΕΞΟΦΛΗΣΗ!`n`n" . apartment . " ξεχρέωσε πλήρως!`n`nΠληρωμή: " Format("{:.2f} €", amount) "`n`n✓ Αποθηκεύτηκε αυτόματα!`n✓ Το διαμέρισμα αφαιρέθηκε από τις λίστες χρεών!", "Επιτυχής Εξόφληση", 0x40)
        } else {
            MsgBox("✓ Καταχωρήθηκε πληρωμή " Format("{:.2f} €", amount) " από " apartment 
                   "`n`n━━━━━━━━━━━━━━━━━━━━━━"
                   "`nΥπόλοιπο χρέος περιόδου: " Format("{:.2f} €", currentDebt)
                   "`nΧρέος προηγ. περιόδων: " Format("{:.2f} €", previousDebt)
                   "`n`n━━━━━━━━━━━━━━━━━━━━━━"
                   "`nΣΥΝΟΛΟ ΥΠΟΛΟΙΠΟΥ: " Format("{:.2f} €", currentDebt + previousDebt)
                   "`n`n✓ Αποθηκεύτηκε αυτόματα!", "Επιτυχία", 0x40)
        }
    }
    
    QuickPaymentGui.Show("w410 h320")
}

; Κλείσιμο εφαρμογής με ΑΥΤΟΜΑΤΗ ΑΠΟΘΗΚΕΥΣΗ
GuiClose(*) {
    global CurrentPeriod
    
    if CurrentPeriod != "" {
        AutoSavePeriod()
    }
    
    ExitApp
}

; ═══════════════════════════════════════════════════════════
; ΛΕΙΤΟΥΡΓΙΕΣ ΑΝΑΦΟΡΩΝ
; ═══════════════════════════════════════════════════════════

; Ενημέρωση λίστας διαμερισμάτων για αναφορές
UpdateReportsApartmentList() {
    global DDApartmentReport, Apartments
    
    DDApartmentReport.Delete()
    
    for apartment in Apartments {
        DDApartmentReport.Add([apartment])
    }
    
    if Apartments.Count > 0
        DDApartmentReport.Choose(1)
}

; Επιλογή φακέλου αποθήκευσης
SelectReportsFolder(*) {
    global EditReportsFolder
    
    SelectedFolder := DirSelect("*" EditReportsFolder.Value, 0, "Επιλέξτε Φάκελο Αποθήκευσης Αναφορών")
    if SelectedFolder != ""
        EditReportsFolder.Value := SelectedFolder
}

; Δημιουργία πίνακα όλων των διαμερισμάτων
GenerateAllApartmentsReport(*) {
    global Apartments, CurrentPeriod, ApartmentDebts, PreviousPeriodDebts, EditReportsFolder, Expenses
    
    if Apartments.Count = 0 {
        MsgBox("Δεν υπάρχουν διαμερίσματα!", "Πληροφορία", 0x40)
        return
    }
    
    if CurrentPeriod = "" {
        MsgBox("Δεν έχει οριστεί περίοδος!", "Σφάλμα", 0x10)
        return
    }
    
    ; Δημιουργία φακέλου αν δεν υπάρχει
    reportsFolder := EditReportsFolder.Value
    if !DirExist(reportsFolder)
        DirCreate(reportsFolder)
    
    ; Υπολογισμός εξόδων
    totalCommon := GetExpenseTotal("Κοινόχρηστα")
    totalElevator := GetExpenseTotal("Ασανσέρ")
    totalHeating := GetExpenseTotal("Θέρμανση")
    totalPrinting := GetExpenseTotal("Έκδοση")
    totalReserve := GetExpenseTotal("Αποθεματικό")
    grandTotal := totalCommon + totalElevator + totalHeating + totalPrinting + totalReserve
    
    ; Υπολογισμός συνόλου θέρμανσης
    totalHeatingPercent := 0
    for apartment, data in Apartments {
        if data.hasHeating
            totalHeatingPercent += Number(data.heating)
    }
    
    ; Δημιουργία αρχείου
    fileName := reportsFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_Πίνακας_Διαμερισμάτων.txt"
    
    content := ""
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "           ΠΙΝΑΚΑΣ ΔΙΑΜΕΡΙΣΜΑΤΩΝ ΠΟΛΥΚΑΤΟΙΚΙΑΣ`n"
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "`n"
    content .= "Περίοδος: " CurrentPeriod "`n"
    content .= "Ημερομηνία: " FormatTime(A_Now, "dd/MM/yyyy") "`n"
    content .= "`n"
    content .= "-----------------------------------------------------------`n"
    content .= "ΑΝΑΛΥΤΙΚΑ ΕΞΟΔΑ ΠΟΛΥΚΑΤΟΙΚΙΑΣ`n"
    content .= "-----------------------------------------------------------`n"
    content .= "`n"
    
    ; Ανάλυση κοινοχρήστων (με λατινικούς χαρακτήρες)
    kathariotita := 0
    reuma := 0
    nero := 0
    pyroasfaleia := 0
    kipouros := 0
    alla := 0
    
    for id, expense in Expenses {
        if expense.category = "Κοινόχρηστα" {
            switch expense.type {
                case "Καθαριότητα": kathariotita += expense.amount
                case "Ηλ. Ρεύμα": reuma += expense.amount
                case "Νερό": nero += expense.amount
                case "Πυρασφάλεια": pyroasfaleia += expense.amount
                case "Κηπουρός": kipouros += expense.amount
                default: alla += expense.amount
            }
        }
    }
    
    content .= "ΚΑΘΑΡΙΟΤΗΤΑ:         " PadLeft(Format("{:.2f}", kathariotita), 10) " €`n"
    content .= "ΗΛΕΚΤΡΙΚΟ ΡΕΥΜΑ:     " PadLeft(Format("{:.2f}", reuma), 10) " €`n"
    content .= "ΝΕΡΟ:                " PadLeft(Format("{:.2f}", nero), 10) " €`n"
    content .= "ΠΥΡΑΣΦΑΛΕΙΑ:         " PadLeft(Format("{:.2f}", pyroasfaleia), 10) " €`n"
    content .= "ΚΗΠΟΥΡΟΣ:            " PadLeft(Format("{:.2f}", kipouros), 10) " €`n"
    content .= "ΑΛΛΑ ΕΞΟΔΑ:          " PadLeft(Format("{:.2f}", alla), 10) " €`n"
    content .= "                     ------------`n"
    content .= "ΣΥΝΟΛΟ ΚΟΙΝΟΧΡΗΣΤΩΝ: " PadLeft(Format("{:.2f}", totalCommon), 10) " €`n"
    content .= "`n"
    content .= "ΑΣΑΝΣΕΡ:             " PadLeft(Format("{:.2f}", totalElevator), 10) " €`n"
    content .= "ΘΕΡΜΑΝΣΗ:            " PadLeft(Format("{:.2f}", totalHeating), 10) " €`n"
    content .= "ΕΚΔΟΣΗ:              " PadLeft(Format("{:.2f}", totalPrinting), 10) " €`n"
    content .= "ΑΠΟΘΕΜΑΤΙΚΟ:         " PadLeft(Format("{:.2f}", totalReserve), 10) " €`n"
    content .= "                     ============`n"
    content .= "ΓΕΝΙΚΟ ΣΥΝΟΛΟ:       " PadLeft(Format("{:.2f}", grandTotal), 10) " €`n"
    content .= "`n"
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "ΠΙΝΑΚΑΣ ΔΙΑΜΕΡΙΣΜΑΤΩΝ`n"
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "`n"
    content .= PadRight("Διαμέρισμα", 15)
    content .= PadRight("Ιδιοκτήτης", 24)
    content .= PadRight("Κοινοχ. ΧΙΛ.", 15)
    content .= PadRight("Ασανσέρ ΧΙΛ.", 16)
    content .= PadRight("Θέρμανση ΧΙΛ.", 16)
    content .= PadRight("Εκτύπωση %", 15)
    content .= PadRight("Πληρωτέο Ποσό", 16)
    content .= "`n"
    content .= "-----------------------------------------------------------`n"
    
    totalSumCommon := 0
    totalSumElevator := 0
    totalSumHeating := 0
    totalSumPercentage := 0
    
    for apartment, data in Apartments {
        ; Υπολογισμός οφειλής
        commonDebt := (Number(data.common) / 1000) * totalCommon
        elevatorDebt := (Number(data.elevator) / 1000) * totalElevator
        printingDebt := (Number(data.percentage) / 100) * totalPrinting
        reserveDebt := (Number(data.common) / 1000) * totalReserve
        
        heatingDebt := 0
        if data.hasHeating && totalHeatingPercent > 0
            heatingDebt := (Number(data.heating) / totalHeatingPercent) * totalHeating
        
        currentDebt := ApartmentDebts.Has(apartment) ? ApartmentDebts[apartment] : 0
        previousDebt := PreviousPeriodDebts.Has(apartment) ? PreviousPeriodDebts[apartment] : 0
        totalDebt := currentDebt + previousDebt
        
        content .= PadRight(apartment, 15)
        content .= PadRight(SubStr(data.owner, 1, 20), 24)
        content .= PadLeft(data.common, 14) " "
        content .= PadLeft(data.elevator, 15) " "
        content .= PadLeft(data.hasHeating ? data.heating : "0", 15) " "
        content .= PadLeft(Format("{:.2f}", data.percentage), 14) " "
        content .= PadLeft(Format("{:.2f}", totalDebt), 13) " €"
        content .= "`n"
        
        totalSumCommon += Number(data.common)
        totalSumElevator += Number(data.elevator)
        if data.hasHeating
            totalSumHeating += Number(data.heating)
        totalSumPercentage += Number(data.percentage)
    }
    
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= PadRight("ΣΥΝΟΛΟ", 39)
    content .= PadLeft(Format("{:.0f}", totalSumCommon), 14) " "
    content .= PadLeft(Format("{:.0f}", totalSumElevator), 15) " "
    content .= PadLeft(Format("{:.0f}", totalSumHeating), 15) " "
    content .= PadLeft(Format("{:.2f}", totalSumPercentage), 14) " "
    content .= PadLeft(Format("{:.2f}", CalculateTotalDebts()), 13) " €"
    content .= "`n"
    
    try {
        FileDelete(fileName)
    }
    
    FileAppend(content, fileName, "UTF-8")
    
    MsgBox("Ο πίνακας διαμερισμάτων δημιουργήθηκε!`n`nΑρχείο:`n" fileName, "Επιτυχία", 0x40)
    Run(fileName)
}

; Δημιουργία αναλυτικής αναφοράς διαμερίσματος
GenerateSingleApartmentReport(*) {
    global DDApartmentReport, Apartments, CurrentPeriod, ApartmentDebts, PreviousPeriodDebts, EditReportsFolder
    
    if DDApartmentReport.Text = "" {
        MsgBox("Επιλέξτε διαμέρισμα!", "Σφάλμα", 0x10)
        return
    }
    
    if CurrentPeriod = "" {
        MsgBox("Δεν έχει οριστεί περίοδος!", "Σφάλμα", 0x10)
        return
    }
    
    apartment := DDApartmentReport.Text
    if !Apartments.Has(apartment) {
        MsgBox("Το διαμέρισμα δεν βρέθηκε!", "Σφάλμα", 0x10)
        return
    }
    
    reportsFolder := EditReportsFolder.Value
    if !DirExist(reportsFolder)
        DirCreate(reportsFolder)
    
    GenerateDetailedApartmentReport(apartment, reportsFolder)
    
    fileName := reportsFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_" apartment "_Αναλυτική.txt"
    MsgBox("Η αναλυτική για το " apartment " δημιουργήθηκε!`n`nΑρχείο:`n" fileName, "Επιτυχία", 0x40)
    Run(fileName)
}

; Δημιουργία αναλυτικών για όλα τα διαμερίσματα
GenerateAllDetailedReports(*) {
    global Apartments, CurrentPeriod, EditReportsFolder
    
    if Apartments.Count = 0 {
        MsgBox("Δεν υπάρχουν διαμερίσματα!", "Πληροφορία", 0x40)
        return
    }
    
    if CurrentPeriod = "" {
        MsgBox("Δεν έχει οριστεί περίοδος!", "Σφάλμα", 0x10)
        return
    }
    
    if MsgBox("Θα δημιουργηθούν " Apartments.Count " αρχεία (ένα για κάθε διαμέρισμα).`n`nΣυνέχεια;", "Επιβεβαίωση", 0x34) = "No"
        return
    
    reportsFolder := EditReportsFolder.Value
    if !DirExist(reportsFolder)
        DirCreate(reportsFolder)
    
    count := 0
    for apartment in Apartments {
        GenerateDetailedApartmentReport(apartment, reportsFolder)
        count++
    }
    
    MsgBox("Δημιουργήθηκαν " count " αναλυτικές αναφορές!`n`nΦάκελος:`n" reportsFolder, "Επιτυχία", 0x40)
    Run(reportsFolder)
}

; Βοηθητική συνάρτηση - Δημιουργία αναλυτικής
GenerateDetailedApartmentReport(apartment, reportsFolder) {
    global Apartments, CurrentPeriod, ApartmentDebts, PreviousPeriodDebts, Expenses
    
    data := Apartments[apartment]
    
    ; Υπολογισμός εξόδων
    totalCommon := GetExpenseTotal("Κοινόχρηστα")
    totalElevator := GetExpenseTotal("Ασανσέρ")
    totalHeating := GetExpenseTotal("Θέρμανση")
    totalPrinting := GetExpenseTotal("Έκδοση")
    totalReserve := GetExpenseTotal("Αποθεματικό")
    
    ; Υπολογισμός συνόλου θέρμανσης
    totalHeatingPercent := 0
    for apt, aptData in Apartments {
        if aptData.hasHeating
            totalHeatingPercent += Number(aptData.heating)
    }
    
    ; Υπολογισμός οφειλών
    commonDebt := (Number(data.common) / 1000) * totalCommon
    elevatorDebt := (Number(data.elevator) / 1000) * totalElevator
    printingDebt := (Number(data.percentage) / 100) * totalPrinting
    reserveDebt := (Number(data.common) / 1000) * totalReserve
    
    heatingDebt := 0
    if data.hasHeating && totalHeatingPercent > 0
        heatingDebt := (Number(data.heating) / totalHeatingPercent) * totalHeating
    
    periodDebt := commonDebt + elevatorDebt + heatingDebt + printingDebt + reserveDebt
    previousDebt := PreviousPeriodDebts.Has(apartment) ? PreviousPeriodDebts[apartment] : 0
    totalDebt := periodDebt + previousDebt
    
    ; Δημιουργία περιεχομένου
    content := ""
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "          ΑΠΟΤΕΛΕΣΜΑΤΑ ΔΙΑΜΕΡΙΣΜΑΤΟΣ: " apartment "`n"
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "Ημερομηνία: " FormatTime(A_Now, "dd/MM/yyyy") "`n"
    content .= "Περίοδος: " CurrentPeriod "`n"
    content .= "`n"
    content .= "Ιδιοκτήτης: " data.owner "`n"
    content .= "Τηλέφωνο: " data.phone "`n"
    content .= "`n"
    content .= "-----------------------------------------------------------`n"
    content .= "ΑΝΑΛΥΤΙΚΟΣ ΥΠΟΛΟΓΙΣΜΟΣ`n"
    content .= "-----------------------------------------------------------`n"
    
    ; Κοινόχρηστα
    content .= "ΚΟΙΝΟΧΡΗΣΤΑ:       " PadLeft(Format("{:.2f}", totalCommon), 10) " € × "
    content .= PadLeft(data.common, 5) " / 1000 = "
    content .= PadLeft(Format("{:.2f}", commonDebt), 10) " €`n"
    
    ; Ασανσέρ
    content .= "ΑΣΑΝΣΕΡ:           " PadLeft(Format("{:.2f}", totalElevator), 10) " € × "
    content .= PadLeft(data.elevator, 5) " / 1000 = "
    content .= PadLeft(Format("{:.2f}", elevatorDebt), 10) " €`n"
    
    ; Θέρμανση
    if data.hasHeating && totalHeatingPercent > 0 {
        content .= "ΘΕΡΜΑΝΣΗ:          " PadLeft(Format("{:.2f}", totalHeating), 10) " € × "
        content .= PadLeft(data.heating, 5) " / " PadLeft(Format("{:.0f}", totalHeatingPercent), 5) " = "
        content .= PadLeft(Format("{:.2f}", heatingDebt), 10) " €`n"
    } else {
        content .= "ΘΕΡΜΑΝΣΗ:          " PadLeft(Format("{:.2f}", totalHeating), 10) " € × "
        content .= PadLeft("0", 5) " / " PadLeft(Format("{:.0f}", totalHeatingPercent), 5) " = "
        content .= PadLeft("0.00", 10) " €`n"
    }
    
    ; Έκδοση
    content .= "ΕΚΔΟΣΗ:            " PadLeft(Format("{:.2f}", totalPrinting), 10) " € × "
    content .= PadLeft(Format("{:.2f}", data.percentage), 5) " / 100 = "
    content .= PadLeft(Format("{:.2f}", printingDebt), 10) " €`n"
    
    ; Αποθεματικό
    content .= "ΑΠΟΘΕΜΑΤΙΚΟ:       " PadLeft(Format("{:.2f}", totalReserve), 10) " € × "
    content .= PadLeft(data.common, 5) " / 1000 = "
    content .= PadLeft(Format("{:.2f}", reserveDebt), 10) " €`n"
    
    content .= "-----------------------------------------------------------`n"
    content .= "ΣΥΝΟΛΟ ΠΕΡΙΟΔΟΥ:                          "
    content .= PadLeft(Format("{:.2f}", periodDebt), 10) " €`n"
    
    if previousDebt > 0 {
        content .= "ΧΡΕΟΣ ΠΡΟΗΓΟΥΜΕΝΩΝ:                       "
        content .= PadLeft(Format("{:.2f}", previousDebt), 10) " €`n"
        content .= "-----------------------------------------------------------`n"
        content .= "ΣΥΝΟΛΙΚΗ ΟΦΕΙΛΗ:                          "
        content .= PadLeft(Format("{:.2f}", totalDebt), 10) " €`n"
    }
    
    content .= "═══════════════════════════════════════════════════════════`n"
    
    ; Αποθήκευση
    fileName := reportsFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_" apartment "_Αναλυτική.txt"
    
    try {
        FileDelete(fileName)
    }
    
    FileAppend(content, fileName, "UTF-8")
}
; Δημιουργία αναφοράς εξόδων
GenerateExpensesReport(*) {
    global Expenses, CurrentPeriod, EditReportsFolder
    
    if CurrentPeriod = "" {
        MsgBox("Δεν έχει οριστεί περίοδος!", "Σφάλμα", 0x10)
        return
    }
    
    reportsFolder := EditReportsFolder.Value
    if !DirExist(reportsFolder)
        DirCreate(reportsFolder)
    
    content := ""
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "           ΙΣΤΟΡΙΚΟ ΕΞΟΔΩΝ - " CurrentPeriod "`n"
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "Ημερομηνία Αναφοράς: " FormatTime(A_Now, "dd/MM/yyyy HH:mm") "`n"
    content .= "`n"
    content .= PadRight("Ημερομηνία", 13)
    content .= PadRight("Ποσό", 13)
    content .= PadRight("Κατηγορία", 18)
    content .= PadRight("Είδος", 25)
    content .= PadRight("Περιγραφή", 30)
    content .= "`n"
    content .= "-----------------------------------------------------------`n"
    
    totalAmount := 0
    for id, expense in Expenses {
        content .= PadRight(expense.date, 13)
        content .= PadLeft(Format("{:.2f}", expense.amount), 11) " €"
        content .= " " PadRight(expense.category, 17)
        content .= PadRight(SubStr(expense.type, 1, 22), 25)
        content .= SubStr(expense.description, 1, 30)
        content .= "`n"
        totalAmount += expense.amount
    }
    
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "ΓΕΝΙΚΟ ΣΥΝΟΛΟ:                          "
    content .= PadLeft(Format("{:.2f}", totalAmount), 10) " €`n"
    content .= "═══════════════════════════════════════════════════════════`n"
    
    fileName := reportsFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_Ιστορικό_Εξόδων.txt"
    
    try {
        FileDelete(fileName)
    }
    
    FileAppend(content, fileName, "UTF-8")
    
    MsgBox("Το ιστορικό εξόδων δημιουργήθηκε!`n`nΑρχείο:`n" fileName, "Επιτυχία", 0x40)
    Run(fileName)
}

; Δημιουργία αναφοράς συναλλαγών
GenerateTransactionsReport(*) {
    global Treasury, CurrentPeriod, EditReportsFolder
    
    if CurrentPeriod = "" {
        MsgBox("Δεν έχει οριστεί περίοδος!", "Σφάλμα", 0x10)
        return
    }
    
    reportsFolder := EditReportsFolder.Value
    if !DirExist(reportsFolder)
        DirCreate(reportsFolder)
    
    content := ""
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "        ΙΣΤΟΡΙΚΟ ΣΥΝΑΛΛΑΓΩΝ - " CurrentPeriod "`n"
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "Ημερομηνία Αναφοράς: " FormatTime(A_Now, "dd/MM/yyyy HH:mm") "`n"
    content .= "`n"
    content .= "Υπόλοιπο Ταμείου: " Format("{:.2f}", Treasury.Balance) " €`n"
    content .= "Εισπράξεις: " Format("{:.2f}", Treasury.TotalIncome) " €`n"
    content .= "Έξοδα: " Format("{:.2f}", Treasury.TotalExpenses) " €`n"
    content .= "`n"
    content .= PadRight("Ημερομηνία", 13)
    content .= PadRight("Ποσό", 13)
    content .= PadRight("Τύπος", 20)
    content .= PadRight("Διαμέρισμα", 15)
    content .= PadRight("Περιγραφή", 38)
    content .= "`n"
    content .= "-----------------------------------------------------------`n"
    
    for id, trans in Treasury.Transactions {
        content .= PadRight(trans.date, 13)
        amountStr := Format("{:.2f}", Abs(trans.amount))
        if trans.amount < 0
            amountStr := "-" amountStr
        content .= PadLeft(amountStr, 11) " €"
        content .= " " PadRight(trans.type, 19)
        content .= PadRight(trans.apartment, 15)
        content .= SubStr(trans.description, 1, 38)
        content .= "`n"
    }
    
    content .= "═══════════════════════════════════════════════════════════`n"
    content .= "Συνολικές Συναλλαγές: " Treasury.Transactions.Count "`n"
    content .= "═══════════════════════════════════════════════════════════`n"
    
    fileName := reportsFolder "\" RegExReplace(CurrentPeriod, "[^\wΑ-Ωα-ω0-9]", "") "_Ιστορικό_Συναλλαγών.txt"
    
    try {
        FileDelete(fileName)
    }
    
    FileAppend(content, fileName, "UTF-8")
    
    MsgBox("Το ιστορικό συναλλαγών δημιουργήθηκε!`n`nΑρχείο:`n" fileName, "Επιτυχία", 0x40)
    Run(fileName)
}

; Βοηθητικές συναρτήσεις μορφοποίησης
PadRight(text, length) {
    text := String(text)
    while StrLen(text) < length
        text .= " "
    return SubStr(text, 1, length)
}

PadLeft(text, length) {
    text := String(text)
    while StrLen(text) < length
        text := " " text
    return SubStr(text, 1, length)
}