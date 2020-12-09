-- Function:  gpSelect_Movement_PersonalService_XML()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_XML (Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpSelect_Movement_PersonalService_XML(
    IN inMovementId   Integer  ,  -- Подразделение
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob, Summa TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
   DECLARE vbSummMinus_MI TFloat;
   DECLARE vbSummMinus TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

  CREATE TEMP TABLE tmpMI_All (OperDate TDateTime, Invnumber TVarChar, MemberId Integer, SummMinus TFloat) ON COMMIT DROP;
     INSERT INTO tmpMI_All (OperDate, Invnumber, MemberId, SummMinus)
      WITH
          tmpMovement AS (SELECT Movement.Id
                               , Movement.Invnumber
                               , Movement.OperDate
                               , MovementDate_ServiceDate.ValueData ServiceDate
                          FROM Movement
                               LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                                            ON MovementDate_ServiceDate.MovementId = Movement.Id
                                                           AND MovementDate_ServiceDate.DescId     = zc_MovementDate_ServiceDate()
                          WHERE Movement.Id = MovementDate_ServiceDate.MovementId
                            AND Movement.DescId = zc_Movement_PersonalService()
                            AND Movement.Id = inMovementId
                         )

        , tmpMI AS (SELECT Movement.Id                               AS MovementId
                         , Movement.OperDate              
                         , Movement.Invnumber
                         , MovementItem.Id                           AS MovementItemId
                         , MovementItem.Amount                       AS Amount
                         --, MovementItem.ObjectId                     AS PersonalId
                         --, MILinkObject_Member.ObjectId              AS MemberId
                         , ObjectLink_Personal_Member.ChildObjectId  AS MemberId_Personal
                    FROM tmpMovement AS Movement
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId = zc_MI_Master()
                                                AND MovementItem.isErased = FALSE

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                                          ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                              ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                             AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                    )                         

        , tmpMIFloat_SummMinus AS (SELECT MovementItemFloat.*
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                                     AND MovementItemFloat.DescId IN (zc_MIFloat_SummChildRecalc()
                                                                    , zc_MIFloat_SummFineOthRecalc()
                                                                    , zc_MIFloat_SummMinusExtRecalc()
                                                                     )
                                   )

        SELECT tmpMI.OperDate
             , tmpMI.Invnumber
             , tmpMI.MemberId_Personal                        AS MemberId
             , SUM (COALESCE (MIFloat_SummMinus.ValueData,0)) AS SummMinus
        FROM tmpMI
             LEFT JOIN tmpMIFloat_SummMinus AS MIFloat_SummMinus
                                            ON MIFloat_SummMinus.MovementItemId = tmpMI.MovementItemId
        GROUP BY tmpMI.OperDate
               , tmpMI.Invnumber
               , tmpMI.MemberId_Personal
        HAVING SUM (COALESCE (MIFloat_SummMinus.ValueData,0)) <> 0
        ;
        
  CREATE TEMP TABLE tmpMemberMinus (FromId Integer, ToId Integer, ToName TVarChar, Summ TFloat, Summ_all TFloat, BankAccountToId Integer, BankAccountName_to TVarChar, BankAccountFromId Integer, BankAccountName_from TVarChar, BankAccountTo TVarChar,  DetailPayment TVarChar) ON COMMIT DROP;
     INSERT INTO tmpMemberMinus (FromId, ToId, ToName, Summ, Summ_all, BankAccountFromId, BankAccountName_from, BankAccountToId, BankAccountName_to, BankAccountTo, DetailPayment)
        SELECT tmp.FromId
             , tmp.ToId
             , CASE WHEN LENGTH (tmp.ToName) > 36 AND tmp.ToShort <> '' THEN tmp.ToShort ELSE tmp.ToName END ::TVarChar AS ToName
             , tmp.Summ
             , SUM (tmp.Summ) OVER (PARTITION BY tmp.FromId) AS Summ_all
               -- IBAN плательщика
             , tmp.BankAccountFromId
             , tmp.BankAccountFromName AS BankAccountName_from
               --IBAN получателя
             , tmp.BankAccountToId
             , tmp.BankAccountToName   AS BankAccountName_to
               -- № счета получателя
             , tmp.BankAccountTo
             , tmp.DetailPayment
             
        FROM gpSelect_Object_MemberMinus (FALSE, FALSE, inSession) AS tmp
        
             /*LEFT JOIN ObjectLink AS OL_BankAccount_Account_to
                                  ON OL_BankAccount_Account_to.ObjectId = tmp.BankAccountToId
                                 AND OL_BankAccount_Account_to.DescId = zc_ObjectLink_BankAccount_Account()
             LEFT JOIN Object AS Object_Account_to ON Object_Account_to.Id = OL_BankAccount_Account_to.ChildObjectId

             LEFT JOIN ObjectLink AS OL_BankAccount_Account_from
                                  ON OL_BankAccount_Account_from.ObjectId = tmp.BankAccountFromId
                                 AND OL_BankAccount_Account_from.DescId = zc_ObjectLink_BankAccount_Account()
             LEFT JOIN Object AS Object_Account_from ON Object_Account_from.Id = OL_BankAccount_Account_from.ChildObjectId*/

        WHERE tmp.FromId IN (SELECT DISTINCT tmpMI_All.MemberId FROM tmpMI_All)
          AND tmp.isErased = FALSE;

       -- проверка сумма итого по документу должна соответствовать сумме по справочнику
       SELECT tmpMI_All.MemberId, tmpMI_All.SummMinus, tmpMinus.Summ_all
             INTO vbMemberId, vbSummMinus_MI, vbSummMinus
       FROM tmpMI_All
            INNER JOIN (SELECT DISTINCT tmpMemberMinus.FromId, tmpMemberMinus.Summ_all FROM tmpMemberMinus) AS tmpMinus ON tmpMinus.FromId = tmpMI_All.MemberId
       WHERE tmpMI_All.SummMinus <> tmpMinus.Summ_all
         AND inSession <> zfCalc_UserAdmin()
       LIMIT 1;

   IF COALESCE (vbMemberId,0) <> 0
   THEN
        RAISE EXCEPTION 'Ошибка.Для физ. лица <%> сумма удержания по документу <%> не соответствует сумме удержания по стравочнику <%>. Итого разница у <%> человек. Сумма итого в справочнике: <%>. Сумма итого введомости: <%>.'
                       , lfGet_Object_ValueData (vbMemberId), zfConvert_FloatToString (vbSummMinus_MI), zfConvert_FloatToString (vbSummMinus)
                       , (SELECT COUNT(*)
                          FROM tmpMI_All
                               INNER JOIN (SELECT DISTINCT tmpMemberMinus.FromId, tmpMemberMinus.Summ_all FROM tmpMemberMinus) AS tmpMinus ON tmpMinus.FromId = tmpMI_All.MemberId
                          WHERE tmpMI_All.SummMinus <> tmpMinus.Summ_all
                         )
                       , zfConvert_FloatToString ((SELECT SUM (tmpMinus.Summ_all) FROM (SELECT DISTINCT tmpMemberMinus.FromId, tmpMemberMinus.Summ_all FROM tmpMemberMinus) AS tmpMinus))
                       , zfConvert_FloatToString ((SELECT SUM (tmpMI_All.SummMinus) FROM tmpMI_All))
                        ;
   END IF;

  CREATE TEMP TABLE tmpData (AMOUNT           Integer  --Сумма платежа в копейках
                           , CORRSNAME        TVarChar -- Сумма платежа в копейках
                           , DETAILSOFPAYMENT TVarChar --Назначение платежа
                           , CORRACCOUNTNO    TVarChar --№ счета получателя платежа
                           , CORRIBAN         TVarChar --IBAN получателя платежа
                           , ACCOUNTNO        TVarChar --№ счета плательщика
                           , IBAN             TVarChar --IBAN плательщика
                           , CORRBANKID       TVarChar --Код банка получателя платежа (МФО)
                           , CORRIDENTIFYCODE TVarChar --Идентификационный код получателя платежа (ЕГРПОУ)
                           , CORRCOUNTRYID    TVarChar --Код страны корреспондента
                           , DOCUMENTNO       TVarChar --№ документа
                           , VALUEDATE        TDateTime--Дата валютирования
                           , PRIORITY         Integer  --Приоритет
                           , DOCUMENTDATE     TVarChar --Дата документа
                           , ADDENTRIES       TVarChar --Дополнительные реквизиты платежа
                           , PURPOSEPAYMENTID TVarChar  --Код назначения платежа   --????????????????????????????????????????
                           , BANKID           TVarChar --Код банка плательщика (МФО)
                           ) ON COMMIT DROP;

     INSERT INTO tmpData (AMOUNT, CORRSNAME, DETAILSOFPAYMENT, CORRACCOUNTNO, CORRIBAN, ACCOUNTNO, IBAN, CORRBANKID, CORRIDENTIFYCODE, CORRCOUNTRYID, DOCUMENTNO, VALUEDATE, PRIORITY, DOCUMENTDATE, ADDENTRIES, PURPOSEPAYMENTID, BANKID)
       SELECT (tmpMemberMinus.Summ * 100)          ::Integer   AS AMOUNT           --Сумма платежа в копейках
            , tmpMemberMinus.ToName                ::TVarChar  AS CORRSNAME        -- Сумма платежа в копейках
            , tmpMemberMinus.DetailPayment         ::TVarChar  AS DETAILSOFPAYMENT --Назначение платежа
            , tmpMemberMinus.BankAccountTo         ::TVarChar  AS CORRACCOUNTNO    --№ счета получателя платежа
            , tmpMemberMinus.BankAccountName_to    ::TVarChar  AS CORRIBAN         --IBAN получателя платежа
            , ''                                   ::TVarChar  AS ACCOUNTNO        --№ счета плательщика
            , tmpMemberMinus.BankAccountName_from  ::TVarChar  AS IBAN             --IBAN плательщика
            , CASE WHEN TRIM (Object_Bank_to.MFO) <> '' THEN Object_Bank_to.MFO ELSE Object_Bank_to.BankName END :: TVarChar AS CORRBANKID -- Код банка получателя платежа (МФО)
            , CASE WHEN Object_To.DescId = zc_Object_Juridical() THEN COALESCE (ObjectHistory_JuridicalDetails_View.OKPO,'')
                   ELSE COALESCE (ObjectString_INN.ValueData,'')
              END                                  ::TVarChar  AS CORRIDENTIFYCODE --Идентификационный код получателя платежа (ЕГРПОУ)
            , 804                                  ::TVarChar  AS CORRCOUNTRYID    --Код страны корреспондента
            , tmpMI_All.Invnumber                  ::TVarChar  AS DOCUMENTNO       --№ документа
            , Null                                 ::TDateTime AS VALUEDATE        --Дата валютирования
            , 50                                   ::Integer   AS PRIORITY         --Приоритет
            , (lpad (EXTRACT (YEAR FROM tmpMI_All.OperDate)::TVarChar ,4, '0')||lpad (EXTRACT (MONTH FROM tmpMI_All.OperDate)::TVarChar ,2, '0') ||lpad (EXTRACT (DAY FROM tmpMI_All.OperDate)::TVarChar ,2, '0')) ::TVarChar AS DOCUMENTDATE     --Дата документа
            , ''                                   ::TVarChar  AS ADDENTRIES       --Дополнительные реквизиты платежа
            , '002'                                ::TVarChar  AS PURPOSEPAYMENTID --Код назначения платежа   --????????????????????????????????????????
            , CASE WHEN TRIM (Object_Bank_from.MFO) <> '' THEN Object_Bank_from.MFO ELSE Object_Bank_from.BankName END :: TVarChar  AS BANKID           --Код банка плательщика (МФО)
       FROM tmpMI_All
            INNER JOIN tmpMemberMinus ON tmpMemberMinus.FromId = tmpMI_All.MemberId

            LEFT JOIN ObjectLink AS OL_Bank_to
                                 ON OL_Bank_to.ObjectId = tmpMemberMinus.BankAccountToId
                                AND OL_Bank_to.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object_Bank_View AS Object_Bank_to ON Object_Bank_to.Id = OL_Bank_to.ChildObjectId

            LEFT JOIN ObjectLink AS OL_Bank_from
                                 ON OL_Bank_from.ObjectId = tmpMemberMinus.BankAccountFromId
                                AND OL_Bank_from.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object_Bank_View AS Object_Bank_from ON Object_Bank_from.Id = OL_Bank_from.ChildObjectId
            
            LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMemberMinus.ToId

            --если физ лицо или строннее
            LEFT JOIN ObjectString AS ObjectString_INN
                                   ON ObjectString_INN.ObjectId = tmpMemberMinus.ToId
                                  AND ObjectString_INN.DescId IN (zc_ObjectString_Member_INN(), zc_ObjectString_MemberExternal_INN())
            -- если юр. лицо
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = tmpMemberMinus.ToId
            
      ;


     -- Таблица для результата
     CREATE TEMP TABLE _Result (RowData TBlob, Summa TFloat) ON COMMIT DROP;

     -- первые строчки XML
     INSERT INTO _Result(RowData) VALUES ('<?xml version= "1.0" encoding= "windows-1251"?>');
   
     -- данные
     INSERT INTO _Result(RowData) VALUES ('<ROWDATA>');
     INSERT INTO _Result(RowData, Summa)
    SELECT '<ROW '
         || 'AMOUNT ="'||tmp.AMOUNT||'" '
         || 'CORRSNAME="'|| replace (substring (COALESCE (tmp.CORRSNAME,''), 1, 36), '"', '&quot;') :: TVarChar||'" '
         || 'DETAILSOFPAYMENT="'|| replace (COALESCE (tmp.DETAILSOFPAYMENT,''), '"', '&quot;') ::TVarChar||'" '
         || 'CORRACCOUNTNO="'||COALESCE (tmp.CORRACCOUNTNO,'')::TVarChar||'" '
         || 'CORRIBAN="'||COALESCE (tmp.CORRIBAN,'')::TVarChar||'" '
       --|| 'ACCOUNTNO="'||COALESCE (tmp.ACCOUNTNO,'')::TVarChar||'" '
         || 'ACCOUNTNO="'||COALESCE (tmp.IBAN,'')::TVarChar||'" '
         || 'IBAN="'||COALESCE (tmp.IBAN,'')::TVarChar||'" '
         || 'CORRBANKID="'||COALESCE (tmp.CORRBANKID,'')::TVarChar||'" '
         || 'CORRIDENTIFYCODE="'||COALESCE (tmp.CORRIDENTIFYCODE,'')::TVarChar||'" '
         || 'CORRCOUNTRYID="'||COALESCE (tmp.CORRCOUNTRYID,'')::TVarChar||'" '
       --|| 'DOCUMENTNO="'||COALESCE (tmp.DOCUMENTNO,'')::TVarChar||'" '
         || 'DOCUMENTNO="'||CAST (NEXTVAL ('movement_bankaccount_plat_seq') AS TVarChar)||'" '
         
         || 'VALUEDATE="'||COALESCE (tmp.VALUEDATE::TVarChar,'')::TVarChar||'" '
         || 'PRIORITY="'||tmp.PRIORITY||'" '
       --|| 'DOCUMENTDATE="'||tmp.DOCUMENTDATE||'" '
         || 'DOCUMENTDATE="'||(lpad (EXTRACT (YEAR FROM CURRENT_DATE + INTERVAL '0 DAY')::TVarChar ,4, '0')
                            || lpad (EXTRACT (MONTH FROM CURRENT_DATE + INTERVAL '0 DAY')::TVarChar ,2, '0') 
                            || lpad (EXTRACT (DAY FROM CURRENT_DATE + INTERVAL '0 DAY')::TVarChar ,2, '0')) ::TVarChar||'" '
         || 'ADDENTRIES="'||COALESCE (tmp.ADDENTRIES,'')::TVarChar||'" '
         || 'PURPOSEPAYMENTID="'||COALESCE (tmp.PURPOSEPAYMENTID,'')||'" '
         || 'BANKID="'||COALESCE (tmp.BANKID,'')::TVarChar||'" '
         || '/>'
         , tmp.AMOUNT :: TFloat AS Summa
     FROM tmpData AS tmp ;

     --последнии строчки XML
     INSERT INTO _Result(RowData) VALUES ('</ROWDATA>');

     -- Результат
     RETURN QUERY
        SELECT _Result.RowData, _Result.Summa FROM _Result;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 06.09.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalService_XML (inMovementId:= 17651138, inSession:= zfCalc_UserAdmin());
