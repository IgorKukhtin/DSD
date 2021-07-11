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
          tmpBankAccount AS (SELECT DISTINCT
                                    Object_MoneyPlace.Id               AS JuridicalId
                                  , MILinkObject_InfoMoney.ObjectId    AS InfoMoneyId
                                  , MovementItem.ObjectId              AS BankAccountId_main
                                  , MILinkObject_BankAccount.ObjectId  AS BankAccountId
                                  , MIString_Comment.ValueData         AS Comment
                                  , ROW_NUMBER() OVER (Partition by  Object_MoneyPlace.Id, MILinkObject_InfoMoney.ObjectId, MovementItem.ObjectId ORDER BY Movement.Id DESC) AS Ord
                                  , ROW_NUMBER() OVER (Partition by  Object_MoneyPlace.Id, MILinkObject_InfoMoney.ObjectId, MovementItem.ObjectId ORDER BY Movement.Id DESC) AS Ord_byComment   -- комментарий последнего документа
                             FROM Movement
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND COALESCE (MovementItem.Amount,0) < 0
             
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                   ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                  INNER JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
                                                                     AND Object_MoneyPlace.DescId = zc_Object_Juridical()
             
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                   ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                  INNER JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                                                   ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()
             
                                  LEFT JOIN MovementItemString AS MIString_Comment
                                                               ON MIString_Comment.MovementItemId = MovementItem.Id
                                                              AND MIString_Comment.DescId = zc_MIString_Comment()
             
                             WHERE Movement.DescId = zc_Movement_BankAccount()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate --'01.08.2020' AND '08.09.2020'
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND (MovementItem.ObjectId = inBankAccountId_main OR inBankAccountId_main = 0) --4529011   --  р/сч. ОТП банк
                             ORDER BY 2
                             )

          SELECT DISTINCT tmpBankAccount.JuridicalId
                        , tmpBankAccount.InfoMoneyId
                        , tmpBankAccount.BankAccountId_main
                        , tmpBankAccount.BankAccountId
                        , tmp.Comment
          FROM tmpBankAccount
             LEFT JOIN (SELECT tmpBankAccount.*
                        FROM tmpBankAccount
                        WHERE tmpBankAccount.Ord_byComment = 1
                        ) AS tmp ON tmp.JuridicalId = tmpBankAccount.JuridicalId
                                AND tmp.InfoMoneyId = tmpBankAccount.InfoMoneyId
                                AND tmp.BankAccountId_main = tmpBankAccount.BankAccountId_main
                                AND tmp.BankAccountId = tmpBankAccount.BankAccountId
          WHERE tmpBankAccount.ord = 1);

   -- сохраненне данные в справочнике
   CREATE TEMP TABLE tmpJuridicalOrderFinance ON COMMIT DROP AS (
          SELECT Object_JuridicalOrderFinance.Id
               , OL_JuridicalOrderFinance_Juridical.ChildObjectId       AS JuridicalId
               , OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId AS BankAccountId_main
               , OL_JuridicalOrderFinance_BankAccount.ChildObjectId     AS BankAccountId
               , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId       AS InfoMoneyId
               , ROW_NUMBER() OVER (Partition by OL_JuridicalOrderFinance_Juridical.ChildObjectId
                                               , OL_JuridicalOrderFinance_BankAccountMain.ChildObjectId
                                               , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId) AS Ord
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
   UPDATE Object 
    SET isErased = CASE WHEN tmpData.JuridicalId IS NOT NULL THEN FALSE ELSE TRUE END
   FROM tmpJuridicalOrderFinance AS tmpJOF
        LEFT JOIN tmpData ON tmpData.BankAccountId_main = tmpJOF.BankAccountId_main
                         AND tmpData.JuridicalId = tmpJOF.JuridicalId
                         AND tmpData.InfoMoneyId = tmpJOF.InfoMoneyId
                         AND tmpData.BankAccountId = tmpJOF.BankAccountId
   WHERE tmpJOF.Id = Object.Id
     AND Object.DescId = zc_Object_JuridicalOrderFinance();


   -- сохраняем или обновляем данные в справочнике
   PERFORM gpInsertUpdate_Object_JuridicalOrderFinance(ioId                := COALESCE (tmp.Id,0)        :: Integer   ,   -- ключ объекта <>
                                                       inJuridicalId       := tmpData.JuridicalId        :: Integer   ,     
                                                       inBankAccountMainId := tmpData.BankAccountId_main :: Integer   ,
                                                       inBankAccountId     := tmpData.BankAccountId      :: Integer   ,     
                                                       inInfoMoneyId       := tmpData.InfoMoneyId        :: Integer   ,     
                                                       inSummOrderFinance  := 0                          :: TFloat    , 
                                                       inComment           := tmpData.Comment            :: TVarChar  ,
                                                       inSession           := inSession                  :: TVarChar)
   FROM tmpData
        LEFT JOIN (SELECT tmpJOF.*
                   FROM tmpJuridicalOrderFinance AS tmpJOF
                        INNER JOIN Object ON Object.Id = tmpJOF.Id
                                         AND Object.DescId =  zc_Object_JuridicalOrderFinance()
                                         AND Object.isErased = FALSE
                  ) AS tmp
                    ON tmp.BankAccountId_main = tmpData.BankAccountId_main
                   AND tmp.JuridicalId = tmpData.JuridicalId
                   AND tmp.InfoMoneyId = tmpData.InfoMoneyId
                   AND tmp.BankAccountId = tmpData.BankAccountId
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
--