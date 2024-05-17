1 REM *************************************************************
2 REM **            This is a module of the                      **
3 REM ** Anatomically Correct Bulletin Board System (ACBBS)      **
4 REM ** Written and copyrighted April, 1986 by Howard Stateman. **
5 REM ** All Rights reserved. This program is distributed free   **
6 REM ** to the public on the condition that it is not sold or   **
7 REM ** licensed for a fee of any kind, except donations payable**
8 REM ** to Howard, 4546 El Camino B-10 #335 Los Altos, CA 94022 **
9 REM *************************************************************
10 REM HOWCHAT.BAS IS CHAT USER-OBNOXIOUS, Hacked for QuickBasic & PCBoard
15 REM rev 2.0 uses data file for keywords/responses
20 ' $INCLUDE: 'DOORSORC.INT'
25 PROGNAME$ = "CheriChat": RELEASE$ = "2.0": ANSI = NO: CAPS = yes
26 I1$ = "NAME": I2$ = CALLNAME$: CALL ScriptCMD: NA$ = O1$: REM make NA$ Caps/Lc of CALLNAME$
27 REM Exit.Dor.1$ = "I hope this helped you to get off, " + NA$
28 syslen = LEN(SYSFIRST$): REM needed to compute mistake backpaces
29 REM Exit.Dor.2$ = "Returning you to " + BBSNAME$
30 CALL Clrscrn
32 INPUT #1, DAT$: REM input the data file name from config file
33 INPUT #1, LOG$: REM name the chat log file
35 CLOSE #1
40 ON ERROR GOTO 9999
50 DIM W$(40, 11, 3): REM W$(KEYWORD,REPLIES,# OF REPLIES/LAST REPLY#)
60 DIM FUN$(25): REM Room for opening lines
70 GOSUB 6000: REM input the strings
80 LeftTime = CheckTimeLeft: LeftTime$ = STR$(LeftTime)
100 REM How this program is organized:
101 REM Data is read in from the data file given in 5th line of config file.
102 REM The computer's name is the sysop name in 2nd line of config file.
103 REM Data is organized by keyword. Keyword is the word the program
104 REM searches for in the sentence typed by the end user.
105 REM The format is simple. The keyword is followed by the number
106 REM of replies which match that keyword. The replies then follow
107 REM   immediately. The program reads the keyword, and tries to match it
108 REM   in the sentence. If there is no match it jumps to the next keyword.
109 REM   If it finds a match, it then reads the number of replies, and
110 REM   then reads the replies themselves into an array. The complete array
111 REM   is already there, but data only loads as a match is found. The
112 REM   array also has room for a flag showing the last reply for that
113 REM   keyword. As soon as all replies for a given keyword have been
114 REM used up, the program gracefully exits. The exit message varies,
115 REM   depending on the time left.
116 REM Each keyword can handle up to 10 replies. Currently the program
117 REM expects either 3 or 10 replies per keyword.
118 REM
122 REM The number of keywords in this version is 40. If you add more, change
123 REM the DIM statement in line 50. W$(x,y,z) x=number of keywords,
124 REM   y=max number of replies per keyword + 1, z= 3 spaces for flags
125 REM
126 REM   To add more replies, just change the number after the keyword,
127 REM and add the extra replies just below the appropriate keyword
128 REM
129 REM To change the typing speed, change the values in lines 1740-1770
130 REM To change the delay between the end user input and the reply,
131 REM alter the value in line  2020
180 COUNT = 0:
185 CRLF$ = CHR$(13) + CHR$(10)
200 GOSUB 7700
270 SEP$ = STRING$(70, "=")
280 GOSUB 3000: B$ = SEP$: PRINT #2, B$: GOSUB 3500
290 LeftTime = CheckTimeLeft
300 A$ = CALLNAME$ + " Entered Chat on " + LEFT$(DATE$, 5) + " @ " + LEFT$(TIME$, 5) + " With " + STR$(LeftTime) + " minutes left"
315 GOSUB 3000: B$ = A$: PRINT #2, B$: GOSUB 3500
320 GOSUB 3000: B$ = SEP$: PRINT #2, B$: GOSUB 3500
360 GOSUB 4900: REM TIME DELAY FOR SYSOP TO START TYPING
370 CALL send(SYSFIRST$ + ">", NO, NO, 15): GOSUB 7900: GOSUB 1670: REM 7900 LOADS DIFFERENT GREETINGS, DEPENDING ON TIME
380 REM -USER INPUT SECTION- ADDED TO BY LINDSAY JONES ON 8-24-85
390 CALL send("", NO, yes, 15)
395 Z0$ = Z1$: GOSUB 1780
396 A$ = LeftTime$ + "|" + CALLNAME$ + ":" + Z1$: GOSUB 5000
397 IF LEN(Z1$) > 0 AND Z1$ = Z0$ THEN 1650: REM GET INPUT//CHECK DUPES
398 I$ = Z1$: COUNT = COUNT + 1
400 REM IF LEN(I$) > 80 THEN I$ = LEFT$(I$, 80): REM ONLY PROCESS 1st 80 CHARS
405 IF LEFT$(I$, 2) = "I " THEN I$ = RIGHT$(I$, (LEN(I$) - 1)): REM CHOP OFF LEADING "I"'S
410 IF LEFT$(I$, 3) = "BYE" OR LEFT$(I$, 4) = "QUIT" OR LEFT$(I$, 4) = "EXIT" THEN I$ = "X": GOTO 450
420 IF LEFT$(I$, 1) = "" OR LEN(I$) < 3 THEN F$ = "Say what, " + NA$ + " ?": GOSUB 810: GOTO 390
430 REM IF COUNT = 14 THEN F$ = "How long have you fucked goats, " + NA$ + " ?": GOSUB 810: GOTO 390
435 IF COUNT > 20 THEN 1650: REM limit of 20 q's/responses
440 REM CHAT ROUTINE BOMBOUT BY HOWARD STATEMAN 8/85
450 IF I$ = "X" THEN GOTO 1630
460 I$ = " " + I$ + " "
500 REM FIND THE KEYWORD IN THE SENTENCE
510 RR$ = ""
520 FOR X = 1 TO 40
530 WW$ = W$(X, 1, 1): LW = LEN(WW$): REM get keyword & its length
540 FOR Y = 1 TO LEN(I$) - (LW)
550 IF MID$(I$, Y, LW) = WW$ THEN RR$ = WW$: GOTO 640: REM we have a match
560 NEXT Y
570 NEXT X
630 RR$ = "NOMATCH": X = X - 1: REM X-1 because NOMATCH is 40, X is now 41...we don't have a match, so use NOMATCH list
640 IF W$(X, 1, 3) = "" THEN W$(X, 1, 3) = W$(X, 1, 2): REM plug in the max # for that keyword
700 IF W$(X, 1, 3) = "10" THEN F$ = W$(X, 11, 1): W$(X, 1, 3) = "9": GOTO 800
710 IF W$(X, 1, 3) = "9" THEN F$ = W$(X, 10, 1): W$(X, 1, 3) = "8": GOTO 800
720 IF W$(X, 1, 3) = "8" THEN F$ = W$(X, 9, 1): W$(X, 1, 3) = "7": GOTO 800
730 IF W$(X, 1, 3) = "7" THEN F$ = W$(X, 8, 1): W$(X, 1, 3) = "6": GOTO 800
740 IF W$(X, 1, 3) = "6" THEN F$ = W$(X, 7, 1): W$(X, 1, 3) = "5": GOTO 800
750 IF W$(X, 1, 3) = "5" THEN F$ = W$(X, 6, 1): W$(X, 1, 3) = "4": GOTO 800
760 IF W$(X, 1, 3) = "4" THEN F$ = W$(X, 5, 1): W$(X, 1, 3) = "3": GOTO 800
770 IF W$(X, 1, 3) = "3" THEN F$ = W$(X, 4, 1): W$(X, 1, 3) = "2": GOTO 800
780 IF W$(X, 1, 3) = "2" THEN F$ = W$(X, 3, 1): W$(X, 1, 3) = "1": GOTO 800
790 IF W$(X, 1, 3) = "1" THEN F$ = W$(X, 2, 1): W$(X, 1, 3) = "0": GOTO 800
795 IF W$(X, 1, 3) = "0" THEN 1650
800 REM Print THE REPLY
810 CALL send(SYSFIRST$ + ">", NO, NO, 15): GOSUB 1670: GOTO 380
1630 REM BOMBOUT SEQUENCE
1640 REM IF I$="HELP" THEN F$="SORRY, YOU'RE BEYOND HELP!":GOSUB 1670
1650 CALL send(SYSFIRST$ + ">", NO, NO, 15): F$ = "Bye-bye, " + NA$: GOSUB 1670
1660 CLOSE
1665 CALL Clrscrn: CALL exitdoor: REM CHAIN "ACBBS"
1670 REM TYPING SIMULATION SUBROUTINE
1673 A$ = SYSFIRST$ + ":" + F$: GOSUB 5000
1675 GOSUB 4900: REM 'THINKING' DELAY
1677 BCNT = BCNT + 1: REM mistakes counter
1680 FOR X = 1 TO LEN(F$)
1690 GOSUB 8000: REM MISTAKE GENERATOR
1700 GOSUB 1740
1710 CALL send(MID$(F$, X, 1), NO, NO, 15)
1720 NEXT X
1730 RETURN
1735 REM ADDS TYPING-LIKE DELAYS (called from line 1700)
1740 PP = RandNum(0, 25):
1770 FOR P = 1 TO (PP * 20): NEXT P: RETURN
1780 REM ************* SUBROUTINE TO INPUT  ***
1790 CALL Incomm(LeftTime$ + "|" + NA$ + ">", NO, NO, 15): Z1$ = UCASE$(ARG$): REM ARG$ is INcomm return string
1800 RETURN
3000 LeftTime = CheckTimeLeft: LeftTime$ = STR$(LeftTime): IF LeftTime < 5 THEN 1660
3010 FIL$ = LOG$
3020 OPEN FIL$ FOR APPEND AS #2: REM KEEP TRACK OF CONVERSATIONS
3030 RETURN
3500 CLOSE #2
3510 RETURN
4900 REM VARIABLE DELAY TIME FOR SYSOP'S RESPONSE
4910 XS = RandNum(0, 100)
4920 FOR Z10 = 1 TO (XS * 100)
4930 NEXT Z10
4940 RETURN
5000 REM INPUT OPTIONS
5010 IF LEN(A$) > 152 THEN 5100 ELSE IF LEN(A$) > 75 THEN 5200 ELSE 5300
5100 REM 3-LINE INPUT STRING
5110 AA$ = LeftTime$ + LEFT$(A$, 75)
5120 GOSUB 3000: B$ = AA$: PRINT #2, B$: GOSUB 3500
5130 AB$ = MID$(A$, 76, 75)
5140 GOSUB 3000: B$ = AB$: PRINT #2, B$: GOSUB 3500
5150 AC$ = MID$(A$, 152, 78)
5170 GOSUB 3000: B$ = AC$: PRINT #2, B$: GOSUB 3500
5180 RETURN
5200 REM 2-LINE INPUT STRING
5210 AA$ = LEFT$(A$, 75)
5220 GOSUB 3000: B$ = AA$: PRINT #2, B$: GOSUB 3500
5230 AC$ = MID$(A$, 76, 75)
5270 GOSUB 3000: B$ = AC$: PRINT #2, B$: GOSUB 3500
5280 RETURN
5300 REM 1-LINE INPUT STRING
5310 AC$ = A$
5370 GOSUB 3000: B$ = AC$: PRINT #2, B$: GOSUB 3500
5380 RETURN
6000 REM Load the strings
6010 OPEN DAT$ FOR INPUT AS #3
6020 FOR X = 1 TO 40
6030 INPUT #3, W$(X, 1, 1)
6040 INPUT #3, W$(X, 1, 2): L = VAL(W$(X, 1, 2))
6050 FOR Y = 2 TO L + 1
6060 INPUT #3, W$(X, Y, 1)
6070 NEXT Y
6080 NEXT X
6090 FOR X = 1 TO 25
6100 INPUT #3, FUN$(X)
6110 NEXT X
6120 CLOSE #3
6130 RETURN
7700 REM Check time left
7710 LeftTime$ = STR$(LeftTime)
7720 IF LeftTime < 6 THEN 1660: REM Exit the program
7730 RETURN
7900 REM Greetings chooser (random)
7910 FunTime = RandNum(1, 25): REM make choice of opening line random
7920 F$ = FUN$(FunTime) + " " + NA$
7930 RETURN
8000 REM MISTAKE GENERATOR
8005 fuckup = RandNum(1, 25): REM Randomize which lines get typos
8006 IF fuckup = 1 THEN 8010
8007 IF fuckup = 3 THEN 8015
8008 IF fuckup = 7 THEN 8017
8009 IF fuckup = 12 THEN 8018 ELSE 8020
8010 IF (X = 5 OR X = 15 OR X = 52) THEN 8030 ELSE 8020
8015 IF (X = 8 OR X = 20 OR X = 62) THEN 8050 ELSE 8020
8017 IF (X = 18 OR X = 23 OR X = 26) THEN 8030 ELSE 8020
8018 IF (X = 12 OR X = 23 OR X = 36) THEN 8050 ELSE 8020
8020 RETURN
8030 fuck$ = MID$(F$, X - 1, 3): PP = 200: GOSUB 1770: REM long delay
8040 CALL send(fuck$, NO, NO, 15): PP = 200: GOSUB 1770: CALL BackSpaceToCol(X + syslen): PP = 200: GOSUB 1770: CALL send(MID$(F$, X - 1, 1), NO, NO, 15): PP = 200: GOSUB 1770: CALL send(MID$(F$, X, 1), NO, NO, 15): X = X + 1: GOTO 8070
8050 fuck$ = MID$(F$, X - 1, 5): PP = 200: GOSUB 1770:   REM long delay
8060 CALL send(fuck$, NO, NO, 15): PP = 200: GOSUB 1770: CALL BackSpaceToCol(X + syslen + 1): PP = 200: GOSUB 1770: CALL send(MID$(F$, X - 1, 1), NO, NO, 15): PP = 200: GOSUB 1770: CALL send(MID$(F$, X, 1), NO, NO, 15): X = X + 1: GOTO 8070
8070 RETURN
9000 END
9999 RESUME NEXT

