-- Function: gpInsert_Object_JuridicalOrderFinance_byBankAccount()

DROP FUNCTION IF EXISTS gpInsert_Object_JuridicalOrderFinance_byBankAccount (TDateTime, TDateTime, Integer, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsert_Object_JuridicalOrderFinance_byBankAccount(
    IN inStartDate               TDateTime   , --
    IN inEndDate                 TDateTime   , --
    IN inBankAccountId_main       Integer     , --
    IN inSession                 TVarChar      -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);


   -- данные из документов zc_Movement_BankAccount за выбранный период
   CREATE TEMP TABLE tmpData ON COMMIT DROP AS (
          WITH
          tmpBankAccount AS (SELECT Object_MoneyPlace.Id                                    AS JuridicalId
                                  , Movement.OperDate                                       AS OperDate
                                  , MILinkObject_InfoMoney.ObjectId                         AS InfoMoneyId
                                  , MovementItem.ObjectId                                   AS BankAccountId_main
                                  , MILinkObject_BankAccount.ObjectId                       AS BankAccountId
                                  , COALESCE (Object_Bank.Id, 0)                            AS BankId
                                  , -1 * MovementItem.Amount                                AS Amount
                                  , MIString_Comment.ValueData                              AS Comment
                                    -- № п/п
                                  , ROW_NUMBER() OVER (PARTITION BY Object_MoneyPlace.Id, MILinkObject_InfoMoney.ObjectId, MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                                    -- № п/п - комментарий последнего документа
                                  , ROW_NUMBER() OVER (PARTITION BY Object_MoneyPlace.Id, MILinkObject_InfoMoney.ObjectId, MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord_byComment
                             FROM Movement
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         -- Только Мы платим
                                                         AND MovementItem.Amount     < 0

                                  -- Кому оплата
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                   ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                  -- Только Юр.Лица
                                  INNER JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id     = MILinkObject_MoneyPlace.ObjectId
                                                                        AND Object_MoneyPlace.DescId = zc_Object_Juridical()

                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                   ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                  -- на какой Р/сч
                                  INNER JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                                                    ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_BankAccount.DescId         = zc_MILinkObject_BankAccount()
                                  -- найдем банк
                                  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                                       ON ObjectLink_BankAccount_Bank.ObjectId = MILinkObject_BankAccount.ObjectId
                                                      AND ObjectLink_BankAccount_Bank.DescId   = zc_ObjectLink_BankAccount_Bank()
                                  LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
                                                                 -- !!!есть значение!!!
                                                                 AND TRIM (Object_Bank.ValueData) <> ''

                                  -- Назначение платежа
                                  LEFT JOIN MovementItemString AS MIString_Comment
                                                               ON MIString_Comment.MovementItemId = MovementItem.Id
                                                              AND MIString_Comment.DescId = zc_MIString_Comment()

                             WHERE Movement.DescId = zc_Movement_BankAccount()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND (MovementItem.ObjectId = inBankAccountId_main OR inBankAccountId_main = 0)
                            )
            -- Замена на другой р.сч, если не нашли Банк
          , tmpBank_find AS (SELECT tmpBankAccount.JuridicalId
                                  , tmpBankAccount.InfoMoneyId
                                  , tmpBankAccount.BankAccountId_main
                                  , tmpBankAccount.BankAccountId
                                  , Object_BankAccount_find.Id AS BankAccountId_find
                                    -- № п/п
                                  , ROW_NUMBER() OVER (PARTITION BY tmpBankAccount.JuridicalId
                                                                  , tmpBankAccount.InfoMoneyId
                                                                  , tmpBankAccount.BankAccountId_main
                                                                  , tmpBankAccount.BankAccountId
                                                       ORDER BY Object_BankAccount_find.Id ASC
                                                      ) AS Ord
                             FROM tmpBankAccount
                                  LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = tmpBankAccount.BankAccountId
                                  INNER JOIN Object AS Object_BankAccount_find ON TRIM (Object_BankAccount_find.ValueData) ILIKE TRIM (Object_BankAccount.ValueData)
                                                                              AND Object_BankAccount_find.DescId    = zc_Object_BankAccount()
                                                                              AND Object_BankAccount_find.isErased  = FALSE
                                  -- найдем банк
                                  INNER JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                                        ON ObjectLink_BankAccount_Bank.ObjectId      = Object_BankAccount_find.Id
                                                       AND ObjectLink_BankAccount_Bank.DescId        = zc_ObjectLink_BankAccount_Bank()
                                  INNER JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
                                                                  -- !!!есть значение!!!
                                                                  AND TRIM (Object_Bank.ValueData) <> ''

                             WHERE tmpBankAccount.Ord = 1
                               -- не нашли банк
                               AND tmpBankAccount.BankId = 0
                            )
          -- Результат
          SELECT tmpBankAccount.OperDate
               , tmpBankAccount.JuridicalId
               , tmpBankAccount.InfoMoneyId
               , tmpBankAccount.BankAccountId_main
                 -- Замена на другой р.сч
               , COALESCE (tmpBank_find.BankAccountId_find, tmpBankAccount.BankAccountId) AS BankAccountId
                 --
               , tmpBankAccount.Amount
               , tmp.Comment
          FROM tmpBankAccount
               LEFT JOIN (SELECT tmpBankAccount.*
                          FROM tmpBankAccount
                          WHERE tmpBankAccount.Ord_byComment = 1
                         ) AS tmp ON tmp.JuridicalId        = tmpBankAccount.JuridicalId
                                 AND tmp.InfoMoneyId        = tmpBankAccount.InfoMoneyId
                                 AND tmp.BankAccountId_main = tmpBankAccount.BankAccountId_main
                                 AND tmp.BankAccountId      = tmpBankAccount.BankAccountId
               -- Замена на другой р.сч
               LEFT JOIN tmpBank_find ON tmpBank_find.JuridicalId        = tmpBankAccount.JuridicalId
                                     AND tmpBank_find.InfoMoneyId        = tmpBankAccount.InfoMoneyId
                                     AND tmpBank_find.BankAccountId_main = tmpBankAccount.BankAccountId_main
                                     AND tmpBank_find.BankAccountId      = tmpBankAccount.BankAccountId
          -- берется только ОДИН
          WHERE tmpBankAccount.ord = 1
         );

   -- данные из справочника
   CREATE TEMP TABLE tmpJuridicalOrderFinance ON COMMIT DROP
      AS (SELECT Object_JuridicalOrderFinance.Id                        AS Id
               , OL_JuridicalOrderFinance_Juridical.ChildObjectId       AS JuridicalId
               , OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId AS BankAccountId_main
               , OL_JuridicalOrderFinance_BankAccount.ChildObjectId     AS BankAccountId
               , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId       AS InfoMoneyId
                 -- № п/п
               , ROW_NUMBER() OVER (PARTITION BY OL_JuridicalOrderFinance_Juridical.ChildObjectId
                                               , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId
                                               , OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId
                                               , OL_JuridicalOrderFinance_BankAccount.ChildObjectId
                                    ORDER BY Object_JuridicalOrderFinance.Id DESC
                                   ) AS Ord
          FROM Object AS Object_JuridicalOrderFinance
              INNER JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccountMain
                                    ON OL_JuridicalOrderFinance_BankAccountMain.ObjectId = Object_JuridicalOrderFinance.Id
                                   AND OL_JuridicalOrderFinance_BankAccountMain.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccountMain()
                                   AND (OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId = inBankAccountId_main OR inBankAccountId_main = 0)

              LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccount
                                   ON OL_JuridicalOrderFinance_BankAccount.ObjectId = Object_JuridicalOrderFinance.Id
                                  AND OL_JuridicalOrderFinance_BankAccount.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccount()

              LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                   ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                                  AND OL_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()

              LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                   ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                  AND OL_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()
          WHERE Object_JuridicalOrderFinance.DescId = zc_Object_JuridicalOrderFinance()
         );

   -- удаляем сохраненные элементы справочника, которых нет в выборке по документам
   UPDATE Object SET isErased = CASE WHEN tmpData.JuridicalId > 0 AND tmpJuridical.Ord = 1 THEN FALSE ELSE TRUE END
   FROM tmpJuridicalOrderFinance AS tmpJuridical
        LEFT JOIN tmpData ON tmpData.BankAccountId_main = tmpJuridical.BankAccountId_main
                         AND tmpData.JuridicalId        = tmpJuridical.JuridicalId
                         AND tmpData.InfoMoneyId        = tmpJuridical.InfoMoneyId
                         AND tmpData.BankAccountId      = tmpJuridical.BankAccountId
   WHERE tmpJuridical.Id = Object.Id
     AND Object.DescId = zc_Object_JuridicalOrderFinance()
  ;


   -- сохраняем или обновляем данные в справочнике
   PERFORM gpInsertUpdate_Object_JuridicalOrderFinance(ioId                := COALESCE (tmp.Id,0)        :: Integer   ,   -- ключ объекта <>
                                                       inOperDate          := tmpData.OperDate,
                                                       inJuridicalId       := tmpData.JuridicalId        :: Integer   ,
                                                       inBankAccountMainId := tmpData.BankAccountId_main :: Integer   ,
                                                       inBankAccountId     := tmpData.BankAccountId      :: Integer   ,
                                                       inInfoMoneyId       := tmpData.InfoMoneyId        :: Integer   ,
                                                       inSummOrderFinance  := COALESCE ((SELECT OFl.ValueData FROM ObjectFloat AS OFl
                                                                                         WHERE OFl.ObjectId = tmp.Id
                                                                                           AND OFl.DescId = zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance()
                                                                                        ), 0),
                                                       inAmount            := tmpData.Amount,
                                                       inComment           := tmpData.Comment            :: TVarChar  ,
                                                       inSession           := inSession                  :: TVarChar
                                                      )
   FROM tmpData
        LEFT JOIN (SELECT tmpJuridical.*
                   FROM tmpJuridicalOrderFinance AS tmpJuridical
                        INNER JOIN Object ON Object.Id       = tmpJuridical.Id
                                         AND Object.DescId   = zc_Object_JuridicalOrderFinance()
                                         AND Object.isErased = FALSE
                   WHERE tmpJuridical.Ord = 1
                  ) AS tmp
                    ON tmp.BankAccountId_main = tmpData.BankAccountId_main
                   AND tmp.JuridicalId        = tmpData.JuridicalId
                   AND tmp.InfoMoneyId        = tmpData.InfoMoneyId
                   AND tmp.BankAccountId      = tmpData.BankAccountId
  ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.11.20         *
*/

-- тест
-- SELECT * FROM gpInsert_Object_JuridicalOrderFinance_byBankAccount (inStartDate:= '01.09.2025', inEndDate:= '24.11.2025', inBankAccountId_main:= 0, inSession := '5');
