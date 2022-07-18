; ************************************************************
;       Programme: palindrome.pep     version PEP8.2 sous Windows
;
;       INF2171 - TP1
;       Un programme qui doit tester si un nombre saisie par un utilisateur
;       est un palindrome. Si oui, la somme de chaque chiffre qui le compose
;       multiplie par 2.
;
;       auteur:         Leonid Glazyrin
;       code permanent: GLAL77080105
;       courriel:       de891974@ens.uqam.ca
;       date:           6/12/2022
;       cours:          INF2171
; ***********************************************************
;
         LDA     0,i
         LDX     0,i
         STRO    prompt,d    ;print(prompt)
         DECI    num,d       ;input(num)
;---------------------------------------------
;Gerer si le nombre entree cause un debordement
;
         BRV     debord      ;verifie le flag overflow
         BR      nonDeb      
debord:  STRO    msgDeb,d    ;print(msg)
         STOP
nonDeb:  LDA     num,d       ;A = MEM[num]
;---------------------------------------------
         STRO    msgNum,d    ;print(msg)
         DECO    num,d       ;print(num)
;---------------------------------------------
;Gerer le cas ou le nombre entree est negatif
;
         BRLT    neg         ;if(A < 0):
         BR      positif     ;else
neg:     NEGA                ;A = -A
         BRV     non         ;pour le cas ou nombre entree est -32768
positif: STA     n,d         ;n = A
         STA     numPos,d    ;numPos = A
;---------------------------------------------
;L'algorithme pour construire le nombre decimal inverse
;
         LDX     n,d         ;utile pour la ligne d'apres
loop:    STX     n,d         ;X stocker juste 1 fois au lieu de chaque boucle diviser
         LDA     n,d         ;A = n
         BREQ    compare     ;while(n != 0)
modulo:  CPA     10,i        ;pour ne pas soustraire 10 a un chiffre < 10
         BRLT    restant
         SUBA    10,i        ;(reste = n % 10)
         CPA     10,i        ;si A < 10 on passe a la prochaine etape
         BRLT    restant     ;si n entre 0 et 10 c'est le reste qu'on ajoute au nombre inverser
         BR      modulo      ;on soustrait 10 jusqu'a ce que le nombre est < 10
restant: STA     reste,d     ;stocker le n % 10 dans MEM[reste]
         ASLA                ;A = A * 2
         ADDA    result,d    ;A += result
         STA     result,d    ;result = A
         LDA     inverse,d   ;A = palindrome, pour le multiplier par 10 dans multip 
         LDX     9,i         ;9 pour le faire 10 fois et optimiser la comparaison
multip:  ADDA    inverse,d   ;(palindrome = palidrome * 10) + reste
         SUBX    1,i         ;X est utiliser pour compter combien de *10
         BREQ    ajout       ;if(X = 0)
         BR      multip      ;while(X != 0)
ajout:   ADDA    reste,d     ;palindrome = palidrome * 10 ( + reste )
         STA     inverse,d
         LDA     n,d         ;A = MEM[n]
         LDX     0,i
diviser: CPA     10,i        ;pour ne pas soustraire 10 a un chiffre < 10
         BRLT    loop
         SUBA    10,i        ;n /= 10
         BRLT    loop 
         ADDX    1,i         ;division entiere par 10, ce chiffre sera stocker dans n
         BR      diviser     ;est repete en autant que A > 10
;-------------------------------------------
;Voir si palindrome ou pas
;
compare: LDA     inverse,d
         CPA     numPos,d    ;l'inverse est comparer a celui entree
         BREQ    oui         ;si pareil
         BR      non         ;sinon
;--------------------------------------------
;Sortie si le nomrbre est palindrome
;
oui:     STRO    msgEst,d
         LDA     num,d
         BRLT    resNeg      
         DECO    result,d
         STOP
;--------------------------------------------
;Gerer le cas ou le nombre entree est negatif et donc le resultat des *2 doit etre negatif
;
resNeg:  LDA     result,d
         NEGA    
         STA     result,d
         DECO    result,d
         STOP
;--------------------------------------------
;Sortie si le nombre n'est pas palindrome
non:     STRO    msgPas,d
         STOP
;-----------------------------------------------------
n:       .WORD   0           ;le nombre entree qui est modifier au cours du programme
inverse: .WORD   0           ;le nombre inverser (peut-etre palindrome ou pas)
reste:   .WORD   0           ;sers a stocker un chiffre unique du nombre entree
num:     .WORD   0           ;nombre entree original (+ ou -)
numPos:  .WORD   0           ;nombre entree toujours posifif
result:  .WORD   0           ;le resultat de la multiplication par 2 des chiffres
;-----------------------------------------------------
prompt:  .ASCII  "Un nombre à explorer : \x00"
msgNum:  .ASCII  "Nombre \x00"
msgEst:  .ASCII  " est un palindrome.\nRésultat: \x00"
msgPas:  .ASCII  " n'est pas un palindrome.\n\x00"
msgDeb:  .ASCII  "Débordement !\x00"
;-----------------------------------------------------
         .END