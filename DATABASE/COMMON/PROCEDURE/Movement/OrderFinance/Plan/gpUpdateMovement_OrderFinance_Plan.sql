-- Function: gpUpdateMovement_OrderFinance_Plan()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Plan (Integer, Integer, Boolean,Boolean,Boolean,Boolean,Boolean, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Plan (Integer, Integer, Boolean,Boolean,Boolean,Boolean,Boolean,Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Plan (Integer, Integer, Boolean,Boolean,Boolean,Boolean,Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Plan (Integer, Integer, Boolean,Boolean,Boolean,Boolean,Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Plan (Integer, Integer,Boolean, Boolean,Boolean,Boolean,Boolean,Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Plan (Integer, Integer,Boolean, Boolean,Boolean,Boolean,Boolean,Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_Plan(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId          Integer   , -- Ключ строки
    IN inisAmountPlan            Boolean    , --
    IN inisPlan_1                Boolean    , --
    IN inisPlan_2                Boolean    , --
    IN inisPlan_3                Boolean    , --
    IN inisPlan_4                Boolean    , --
    IN inisPlan_5                Boolean    , --   
    
   OUT outisAmountPlan_1         Boolean    , --
   OUT outisAmountPlan_2         Boolean    , --
   OUT outisAmountPlan_3         Boolean    , --
   OUT outisAmountPlan_4         Boolean    , --
   OUT outisAmountPlan_5         Boolean    , --
    IN inOrderFinanceId          Integer    ,
 INOUT ioJuridicalOrderFinanceId Integer    ,
    IN inJuridicalId             Integer    ,
    IN inInfoMoneyId             Integer    , 
    IN inBankId_main_top         Integer    ,
    IN inBankId_main             Integer    ,
    IN inBankId_jof              Integer    ,
    IN inBankAccountName_main    TVarChar   ,
    IN inBankAccountName_jof     TVarChar   ,  --zc_ObjectLink_JuridicalOrderFinance_BankAccount
    IN inComment_jof             TVarChar   ,
   --IN inComment_pay             TVarChar   ,
   OUT outComment_pay            TVarChar   , 
   OUT outAmountPlan_calc        TFloat     ,
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId     Integer;
            vbBankAccountId_jof   Integer;
            vbBankAccountId_main  Integer;
            vbPlan_count  Integer;
            vbBankId_main Integer;
            vbCount       Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


   /*  IF COALESCE (vbMemberId,0) <> COALESCE (vbMemberId_1,0)
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя нет доступа изменять значения <Согласован-1>.';
     END IF;
     */

     -- Старт
     vbPlan_count:= 0;

     --строки документа
     IF COALESCE (inisPlan_1, FALSE) = TRUE
      THEN
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_1(), inMovementItemId, inisAmountPlan);
        outisAmountPlan_1 := inisAmountPlan;
        --
        vbPlan_count:= vbPlan_count + 1;
     END IF;

     IF COALESCE (inisPlan_2, FALSE) = TRUE
      THEN
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_2(), inMovementItemId, inisAmountPlan);
        outisAmountPlan_2 := inisAmountPlan;
        --
        vbPlan_count:= vbPlan_count + 1;
     END IF;

     IF COALESCE (inisPlan_3, FALSE) = TRUE
      THEN
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_3(), inMovementItemId, inisAmountPlan);
        outisAmountPlan_3 := inisAmountPlan;
        --
        vbPlan_count:= vbPlan_count + 1;
     END IF;

     IF COALESCE (inisPlan_4, FALSE) = TRUE
      THEN
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_4(), inMovementItemId, inisAmountPlan);
        outisAmountPlan_4 := inisAmountPlan;
        --
        vbPlan_count:= vbPlan_count + 1;
     END IF;

     IF COALESCE (inisPlan_5, FALSE) = TRUE
      THEN
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_5(), inMovementItemId, inisAmountPlan);
        outisAmountPlan_5 := inisAmountPlan;
        --
        vbPlan_count:= vbPlan_count + 1;
     END IF;

     -- если не выбрано берем из  inBankId_main_top
     IF COALESCE (inBankId_main,0) = 0
     THEN 
         IF COALESCE (inBankId_main_top, 0) <> 0
         THEN 
             --
             inBankId_main := inBankId_main_top;
         ELSE
             --Если inBankId_main_top тоже пусто то пробуем найти у счета, если там больше 1 банка - тогда выдавать ошибку что надо заполнить "банк плательщика"
              SELECT MAX (Object_BankAccount_View.BankId) AS BankId
                   , COUNT (*) AS Count_bank
            INTO vbBankId_main, vbCount
              FROM Object_BankAccount_View
                   -- Покажем счета только по внутренним фирмам
                   INNER JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                            ON ObjectBoolean_isCorporate.ObjectId = Object_BankAccount_View.JuridicalId
                                           AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                                           AND (ObjectBoolean_isCorporate.ValueData = TRUE
                                             OR Object_BankAccount_View.JuridicalId = 15505 -- ДУКО ТОВ
                                             OR Object_BankAccount_View.JuridicalId = 15512 -- Ірна-1 Фірма ТОВ
                                             OR Object_BankAccount_View.isCorporate = TRUE
                                               )
              WHERE TRIM (Object_BankAccount_View.Name) ILIKE TRIM (inBankAccountName_main)
                AND Object_BankAccount_View.isErased = FALSE
             ;
             IF COALESCE (vbCount,0) = 1
             THEN
                 inBankId_main := vbBankId_main;
             END IF;
             IF COALESCE (vbCount,0) > 1
             THEN
                 RAISE EXCEPTION 'Ошибка.Не заполнен <Банк плательщика>.';
             END IF;             
         END IF;
     END IF;


     --
     IF vbPlan_count > 1
     THEN
         RAISE EXCEPTION 'Ошибка.Выбрано несколько дней недели.%Можно только один.', CHR (13);
     END IF;
     --
     IF vbPlan_count = 0
     THEN
         RAISE EXCEPTION 'Ошибка.День недели не выбран.';
     END IF;


     -- НЕ сохранили свойство <>
     -- PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment_pay(), inMovementItemId, inComment_pay);


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);


     

     -- 2.1. BankAccountName_main
     IF 1=1 -- COALESCE (inBankAccountName_main,'') <> ''
     THEN
         IF TRIM (COALESCE (inBankAccountName_main,'')) = ''
         THEN
           RAISE EXCEPTION 'Ошибка.Р.счет (Плательщик) не выбран.';
         END IF;
         IF COALESCE (inBankId_main, 0) = 0
         THEN
           RAISE EXCEPTION 'Ошибка.Банк (Плательщик) не выбран для счета <%>.', inBankAccountName_main;
         END IF;

         -- пробуем найти
         vbBankAccountId_main:= (SELECT Object_BankAccount_View.Id
                                 FROM Object_BankAccount_View
                                      -- Покажем счета только по внутренним фирмам
                                      INNER JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                                               ON ObjectBoolean_isCorporate.ObjectId = Object_BankAccount_View.JuridicalId
                                                              AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                                                              AND (ObjectBoolean_isCorporate.ValueData = TRUE
                                                                OR Object_BankAccount_View.JuridicalId = 15505 -- ДУКО ТОВ
                                                                OR Object_BankAccount_View.JuridicalId = 15512 -- Ірна-1 Фірма ТОВ
                                                                OR Object_BankAccount_View.isCorporate = TRUE
                                                                  )
                                 WHERE TRIM (Object_BankAccount_View.Name) ILIKE TRIM (inBankAccountName_main)
                                   AND Object_BankAccount_View.isErased = FALSE
                                   AND Object_BankAccount_View.BankId = inBankId_main
                                 --на всякий случай
                                 LIMIT 1
                                );

         IF COALESCE (vbBankAccountId_main, 0) = 0
         THEN
             -- сохранили <Объект>
             vbBankAccountId_main := lpInsertUpdate_Object(vbBankAccountId_main, zc_Object_BankAccount(), 0, TRIM (inBankAccountName_main));

             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), vbBankAccountId_main, 9399);      --9399   "АЛАН ТОВ"
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), vbBankAccountId_main, inBankId_main);

             -- сохранили протокол
             PERFORM lpInsert_ObjectProtocol (vbBankAccountId_main, vbUserId);
         END IF;
     END IF;

     -- 2.2. BankAccount
     IF 1=1 -- COALESCE (inBankAccountName_jof,'') <> ''
     THEN
         IF TRIM (COALESCE (inBankAccountName_jof,'')) = ''
         THEN
           RAISE EXCEPTION 'Ошибка.Р.счет (Получатель) не выбран.';
         END IF;
         IF COALESCE (inBankId_jof, 0) = 0
         THEN
           RAISE EXCEPTION 'Ошибка.Банк(Получатель) не выбран для счета <%>.', inBankAccountName_jof;
         END IF;


         -- пробуем найти
         vbBankAccountId_jof:= (SELECT Object_BankAccount_View.Id
                                FROM Object_BankAccount_View
                                     -- Покажем счета только НЕ по внутренним фирмам
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                                              ON ObjectBoolean_isCorporate.ObjectId = Object_BankAccount_View.JuridicalId
                                                             AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()

                                WHERE TRIM (Object_BankAccount_View.Name) ILIKE TRIM (inBankAccountName_jof)
                                  AND Object_BankAccount_View.isErased = FALSE
                                  AND Object_BankAccount_View.BankId = inBankId_jof
                                 /*AND (ObjectBoolean_isCorporate.ValueData <> TRUE
                                    OR Object_BankAccount_View.JuridicalId <> 15505 -- ДУКО ТОВ
                                    OR Object_BankAccount_View.JuridicalId <> 15512 -- Ірна-1 Фірма ТОВ
                                    OR Object_BankAccount_View.isCorporate <> TRUE
                                      )*/
                                --на всякий случай
                                LIMIT 1
                               );

         IF COALESCE (vbBankAccountId_jof, 0) = 0
         THEN
             -- сохранили <Объект>
             vbBankAccountId_jof := lpInsertUpdate_Object(vbBankAccountId_jof, zc_Object_BankAccount(), 0, TRIM (inBankAccountName_jof));

             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), vbBankAccountId_jof, inJuridicalId);
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), vbBankAccountId_jof, inBankId_jof);

             -- сохранили протокол
             PERFORM lpInsert_ObjectProtocol (vbBankAccountId_jof, vbUserId);
         END IF;


         -- 2.3. Справочник JuridicalOrderFinance_BankAccount
         IF COALESCE (ioJuridicalOrderFinanceId,0) = 0
         THEN
             --сохранили <Объект>
             ioJuridicalOrderFinanceId := lpInsertUpdate_Object (0, zc_Object_JuridicalOrderFinance(), 0, '');
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_Juridical(), ioJuridicalOrderFinanceId, inJuridicalId);
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_BankAccountMain(), ioJuridicalOrderFinanceId, vbBankAccountId_main);
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_InfoMoney(), ioJuridicalOrderFinanceId, inInfoMoneyId);
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_BankAccount(), ioJuridicalOrderFinanceId, vbBankAccountId_jof);
         -- сохранили св-во <>
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_JuridicalOrderFinance_Comment(), ioJuridicalOrderFinanceId, inComment_jof);

         -- сохранили протокол
         PERFORM lpInsert_ObjectProtocol (ioJuridicalOrderFinanceId, vbUserId);

     END IF;    
     
 
     WITH
     tmpJuridicalOrderFinance AS (SELECT ObjectString_Comment.ValueData         :: TVarChar AS Comment
                                       , ROW_NUMBER() OVER (PARTITION BY OL_JuridicalOrderFinance_Juridical.ChildObjectId, Main_BankAccount_View.BankId, OL_JuridicalOrderFinance_InfoMoney.ChildObjectId
                                                            ORDER BY ObjectDate_OperDate.ValueData DESC
                                                            ) AS Ord
                                  FROM Object AS Object_JuridicalOrderFinance
                                       INNER JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                                             ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                                                            AND OL_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()
                                                            AND OL_JuridicalOrderFinance_Juridical.ChildObjectId = inJuridicalId

                                       LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccountMain
                                                            ON OL_JuridicalOrderFinance_BankAccountMain.ObjectId = Object_JuridicalOrderFinance.Id
                                                           AND OL_JuridicalOrderFinance_BankAccountMain.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccountMain()
                                       LEFT JOIN Object_BankAccount_View AS Main_BankAccount_View ON Main_BankAccount_View.Id = OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId

                                       INNER JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                                             ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                                            AND OL_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()
                                                            AND OL_JuridicalOrderFinance_InfoMoney.ChildObjectId = inInfoMoneyId

                                       LEFT JOIN ObjectString AS ObjectString_Comment
                                                              ON ObjectString_Comment.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND ObjectString_Comment.DescId = zc_ObjectString_JuridicalOrderFinance_Comment()

                                       LEFT JOIN ObjectDate AS ObjectDate_OperDate
                                                            ON ObjectDate_OperDate.ObjectId = Object_JuridicalOrderFinance.Id
                                                           AND ObjectDate_OperDate.DescId = zc_ObjectDate_JuridicalOrderFinance_OperDate()
                                  WHERE Object_JuridicalOrderFinance.DescId = zc_Object_JuridicalOrderFinance()
                                   AND Object_JuridicalOrderFinance.isErased = FALSE
                                   AND Object_JuridicalOrderFinance.Id = ioJuridicalOrderFinanceId
                                   AND Main_BankAccount_View.BankId = inBankId_main
                                   AND inBankId_main <> 0
                                   )

   , tmpJuridicalOrderFinance_last AS (SELECT ObjectString_Comment.ValueData         :: TVarChar AS Comment
                                            , ROW_NUMBER() OVER (PARTITION BY OL_JuridicalOrderFinance_Juridical.ChildObjectId, OL_JuridicalOrderFinance_InfoMoney.ChildObjectId
                                                                 ORDER BY ObjectDate_OperDate.ValueData DESC
                                                                ) AS Ord
                                       FROM Object AS Object_JuridicalOrderFinance
                                            INNER JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                                                  ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                                                                 AND OL_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()
                                                                 AND OL_JuridicalOrderFinance_Juridical.ChildObjectId = inJuridicalId

                                            INNER JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                                                  ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                                                 AND OL_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()
                                                                 AND OL_JuridicalOrderFinance_InfoMoney.ChildObjectId = inInfoMoneyId

                                            LEFT JOIN ObjectString AS ObjectString_Comment
                                                                   ON ObjectString_Comment.ObjectId = Object_JuridicalOrderFinance.Id
                                                                  AND ObjectString_Comment.DescId = zc_ObjectString_JuridicalOrderFinance_Comment()

                                            LEFT JOIN ObjectDate AS ObjectDate_OperDate
                                                                 ON ObjectDate_OperDate.ObjectId = Object_JuridicalOrderFinance.Id
                                                                AND ObjectDate_OperDate.DescId = zc_ObjectDate_JuridicalOrderFinance_OperDate()
                                       WHERE Object_JuridicalOrderFinance.DescId = zc_Object_JuridicalOrderFinance()
                                        AND Object_JuridicalOrderFinance.isErased = FALSE
                                        AND Object_JuridicalOrderFinance.Id = ioJuridicalOrderFinanceId
                                        )

     SELECT MIFloat_AmountPlan.ValueData ::TFloat AS AmountPlan_calc
          , CASE WHEN MIFloat_AmountPlan.ValueData > 0
                 THEN REPLACE
                     (REPLACE
                     (REPLACE
                     (REPLACE (COALESCE (tmpJuridicalOrderFinance.Comment, tmpJuridicalOrderFinance_last.Comment)
                                , 'NOM_DOG', COALESCE (View_Contract.InvNumber, ''))
                                , 'DATA_DOG', zfConvert_DateToString (COALESCE (View_Contract.StartDate, zc_DateStart())))
                                , 'PDV', '20')
                                , 'SUMMA_P', zfConvert_FloatToString (ROUND(MIFloat_AmountPlan.ValueData/6, 2))) 
                 ELSE ''
            END :: TVarChar AS Comment_pay 

   INTO outAmountPlan_calc, outComment_pay
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan
                                      ON MIFloat_AmountPlan.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountPlan.DescId = CASE WHEN outisAmountPlan_1 = TRUE THEN zc_MIFloat_AmountPlan_1()
                                                                          WHEN outisAmountPlan_2 = TRUE THEN zc_MIFloat_AmountPlan_2()
                                                                          WHEN outisAmountPlan_3 = TRUE THEN zc_MIFloat_AmountPlan_3()
                                                                          WHEN outisAmountPlan_4 = TRUE THEN zc_MIFloat_AmountPlan_4()
                                                                          WHEN outisAmountPlan_5 = TRUE THEN zc_MIFloat_AmountPlan_5()
                                                                     END
          LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                           ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
          LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MILinkObject_Contract.ObjectId

          --привязка  юр.лицо + статья + выбранный банк (плательщик)
          LEFT JOIN tmpJuridicalOrderFinance ON inBankId_main <> 0
                                            AND tmpJuridicalOrderFinance.Ord = 1

          --привязка  юр.лицо + статья + последний платеж
          LEFT JOIN tmpJuridicalOrderFinance_last ON tmpJuridicalOrderFinance_last.Ord = 1

     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.Id = inMovementItemId
       AND MovementItem.isErased = FALSE
     ;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment_pay(), inMovementItemId, outComment_pay);


     if vbUserId = 9457 then RAISE EXCEPTION 'Админ.Test Ok. <%>', ioJuridicalOrderFinanceId ; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.25         *
*/


-- тест
--select * from gpUpdateMovement_OrderFinance_Plan(inMovementId := 32907603 , inMovementItemId := 341774289 , inisAmountPlan := 'True' , inisPlan_1 := 'False' , inisPlan_2 := 'False' , inisPlan_3 := 'True' , inisPlan_4 := 'False' , inisPlan_5 := 'False' , inOrderFinanceId := 3988049 , ioJuridicalOrderFinanceId := 12995943 , inJuridicalId := 397619 , inInfoMoneyId := 8908 , inBankId_main := 76970 , inBankId_jof := 81452 , inBankAccountName_main := 'UA173005280000026000301367079' , inBankAccountName_jof := 'UA523003350000000026005464177' , inComment_jof := 'За Яловичину, згідно Договору  NOM_DOG у т.ч. ПДВ PDV% SUMMA_P грн.' , inSession := '9457');


/*select * from gpUpdateMovement_OrderFinance_Plan(
inMovementId := 32907603 , 
inMovementItemId := 341774317 , 
inisAmountPlan := 'True' , 
inisPlan_1 := 'False' , 
inisPlan_2 := 'False' , 
inisPlan_3 := 'True' , 
inisPlan_4 := 'False' , 
inisPlan_5 := 'False' , 
inOrderFinanceId := 3988049 , 
ioJuridicalOrderFinanceId := 12996023 , 
inJuridicalId := 11057033 , 
inInfoMoneyId := 8906 , 
inBankId_main_top := 0 ,
inBankId_main := 76970 ,    ---76970
inBankId_jof := 9264405 , 
inBankAccountName_main := 'UA173005280000026000301367079' , 
inBankAccountName_jof := 'UA583209840000026004210394845' , 
inComment_jof := 'За  свиней згідно договору № NOM_DOG у т.ч. ПДВ PDV% SUMMA_P грн.' , 
--inComment_pay := '' ,  
inSession := '9457');

*/
