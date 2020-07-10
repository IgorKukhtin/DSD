-- Function: gpInsert_Object_ReportCollation(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

-- DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat,TFloat,TFloat Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_ReportCollation(
    IN inStartDate           TDateTime,    --
    IN inEndDate             TDateTime,    --
    IN inJuridicalId         Integer,      --
    IN inPartnerId           Integer,      --
    IN inContractId          Integer,      --
    IN inPaidKindId          Integer,      --
    IN InInfoMoneyId         Integer,      --
/*    IN inAccountId           Integer,      --
    IN inCurrencyId          Integer,      --
    IN inMovementId_Partion  Integer,      --
    */
    IN inIsInsert            Boolean,      -- для реестра "Акты сверок"
    IN inIsUpdate            Boolean,      -- добавить визу "Сдали в бухгалтерию"
   OUT outBarCode            TVarChar,     -- штрихкод акта сверки
    IN inSession             TVarChar
)

RETURNS TVarChar
AS
$BODY$
  DECLARE vbId       Integer;
  DECLARE vbUserId   Integer;
  -- DECLARE vbCode_old Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   IF inIsInsert = TRUE
   THEN vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());
   ELSE vbUserId := lpGetUserBySession (inSession);
   END IF;


   IF inIsInsert = TRUE OR inIsUpdate = TRUE
   THEN
       -- проверка - период должен быть строго за месяц - с первого по последнее число месяца
       /*IF inStartDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY' <> inEndDate
          OR inStartDate <> DATE_TRUNC ('MONTH', inStartDate)
       THEN
           RAISE EXCEPTION 'Ошибка.Период должен быть строго за 1 месяц с <%> по <%>.', zfConvert_DateToString (DATE_TRUNC ('MONTH', inStartDate)), zfConvert_DateToString (inStartDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY');
       END IF;*/

       IF 1 < (SELECT COUNT(*)
               FROM ObjectDate AS ObjectDate_Start
                  INNER JOIN Object ON Object.Id       = ObjectDate_Start.ObjectId
                                   AND Object.isErased = FALSE
                  INNER JOIN ObjectDate AS ObjectDate_End
                                        ON ObjectDate_End.ObjectId  = ObjectDate_Start.ObjectId
                                       AND ObjectDate_End.DescId    = zc_ObjectDate_ReportCollation_End()
                                       AND ObjectDate_End.ValueData = inEndDate

                  LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                                       ON ObjectLink_ReportCollation_PaidKind.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()

                  LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                                       ON ObjectLink_ReportCollation_Juridical.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()

                  LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                                       ON ObjectLink_ReportCollation_Partner.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()

                  LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                                       ON ObjectLink_ReportCollation_Contract.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()

                  LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_InfoMoney
                                       ON ObjectLink_ReportCollation_InfoMoney.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_InfoMoney.DescId = zc_ObjectLink_ReportCollation_InfoMoney()

              WHERE ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
                AND ObjectDate_Start.ValueData= inStartDate
                AND (ObjectLink_ReportCollation_PaidKind.ChildObjectId  = COALESCE (inPaidKindId, 0)  OR COALESCE (inPaidKindId, 0)  = 0)
                AND (ObjectLink_ReportCollation_Juridical.ChildObjectId = COALESCE (inJuridicalId, 0) OR COALESCE (inJuridicalId, 0) = 0)
                AND (ObjectLink_ReportCollation_Partner.ChildObjectId   = COALESCE (inPartnerId, 0)   OR COALESCE (inPartnerId, 0)   = 0)
                AND (ObjectLink_ReportCollation_Contract.ChildObjectId  = COALESCE (inContractId, 0)  OR COALESCE (inContractId, 0)  = 0)
                AND (ObjectLink_ReportCollation_InfoMoney.ChildObjectId = COALESCE (inInfoMoneyId, 0) OR COALESCE (inInfoMoneyId, 0) = 0)
             )
       THEN
           RAISE EXCEPTION 'Ошибка.В реестре уже есть акт сверки с такими параметрами.'
                          ;
       END IF;

       -- поиск существующего акта сверки: период, юр.лицо, контрагент, договор, форма оплаты, УП Статья
       vbId:= (SELECT ObjectDate_Start.ObjectId
               FROM ObjectDate AS ObjectDate_Start
                  INNER JOIN Object ON Object.Id       = ObjectDate_Start.ObjectId
                                   AND Object.isErased = FALSE
                  INNER JOIN ObjectDate AS ObjectDate_End
                                        ON ObjectDate_End.ObjectId  = ObjectDate_Start.ObjectId
                                       AND ObjectDate_End.DescId    = zc_ObjectDate_ReportCollation_End()
                                       AND ObjectDate_End.ValueData = inEndDate

                  LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                                       ON ObjectLink_ReportCollation_PaidKind.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()

                  LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                                       ON ObjectLink_ReportCollation_Juridical.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()

                  LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                                       ON ObjectLink_ReportCollation_Partner.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()

                  LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                                       ON ObjectLink_ReportCollation_Contract.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()

                  LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_InfoMoney
                                       ON ObjectLink_ReportCollation_InfoMoney.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_InfoMoney.DescId = zc_ObjectLink_ReportCollation_InfoMoney()

              WHERE ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
                AND ObjectDate_Start.ValueData= inStartDate
                AND (ObjectLink_ReportCollation_PaidKind.ChildObjectId  = COALESCE (inPaidKindId, 0)  OR COALESCE (inPaidKindId, 0)  = 0)
                AND (ObjectLink_ReportCollation_Juridical.ChildObjectId = COALESCE (inJuridicalId, 0) OR COALESCE (inJuridicalId, 0) = 0)
                AND (ObjectLink_ReportCollation_Partner.ChildObjectId   = COALESCE (inPartnerId, 0)   OR COALESCE (inPartnerId, 0)   = 0)
                AND (ObjectLink_ReportCollation_Contract.ChildObjectId  = COALESCE (inContractId, 0)  OR COALESCE (inContractId, 0)  = 0)
                AND (ObjectLink_ReportCollation_InfoMoney.ChildObjectId = COALESCE (inInfoMoneyId, 0) OR COALESCE (inInfoMoneyId, 0) = 0)
             );

         IF inIsUpdate = TRUE AND COALESCE (vbId, 0) = 0
         THEN
              RAISE EXCEPTION 'Ошибка.Виза <Сдали в бухгалтерию> ставится после <Печать для реестра Акты сверок>';
         END IF;


         -- поиск "предыдущего" №п/п
         /*vbCode_old:= (SELECT MAX (Object_ReportCollation.ObjectCode)
                       FROM ObjectDate AS ObjectDate_End
                          INNER JOIN Object AS Object_ReportCollation ON Object_ReportCollation.Id = ObjectDate_End.ObjectId
                                                                     AND Object_ReportCollation.isErased = FALSE
                          INNER JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                                               ON ObjectLink_ReportCollation_PaidKind.ObjectId = ObjectDate_End.ObjectId
                                              AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()
                                              AND (ObjectLink_ReportCollation_PaidKind.ChildObjectId = COALESCE (inPaidKindId,0) OR COALESCE (inPaidKindId,0)=0)

                          INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                                                ON ObjectLink_ReportCollation_Juridical.ObjectId = ObjectDate_End.ObjectId
                                               AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()
                                               AND (ObjectLink_ReportCollation_Juridical.ChildObjectId = COALESCE (inJuridicalId,0) OR COALESCE (inJuridicalId,0)=0)

                          INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                                                ON ObjectLink_ReportCollation_Partner.ObjectId = ObjectDate_End.ObjectId
                                               AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()
                                               AND (ObjectLink_ReportCollation_Partner.ChildObjectId = COALESCE (inPartnerId,0) OR COALESCE (inPartnerId,0)=0)

                          INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                                                ON ObjectLink_ReportCollation_Contract.ObjectId = ObjectDate_End.ObjectId
                                               AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()
                                               AND (ObjectLink_ReportCollation_Contract.ChildObjectId = COALESCE (inContractId,0) OR COALESCE (inContractId,0)=0)
                      WHERE ObjectDate_End.DescId    = zc_ObjectDate_ReportCollation_End()
                        AND ObjectDate_End.ValueData < inStartDate
                     );*/


         IF COALESCE (vbId, 0) = 0 OR inIsUpdate = FALSE
         THEN
             IF COALESCE (vbId, 0) = 0
             THEN
                 -- сохранили <Объект>
                 vbId := lpInsertUpdate_Object( COALESCE (vbId, 0), zc_Object_ReportCollation(), NEXTVAL ('Object_ReportCollation_seq')::Integer, ''::TVarChar);
             END IF;

             --
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Juridical(), vbId, COALESCE (inJuridicalId,0));
             --
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Partner(), vbId, COALESCE (inPartnerId,0));
             --
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Contract(), vbId, COALESCE (inContractId,0));
             --
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_PaidKind(), vbId, COALESCE (inPaidKindId,0));
             --
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_InfoMoney(), vbId, COALESCE (inInfoMoneyId,0));

             -- сохранили свойство <Дата начала периода>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Start(), vbId, inStartDate);
             -- сохранили свойство <Дата окончания периода>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_End(), vbId, inEndDate);


             -- сохранили свойства <>
             PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReportCollation_StartRemainsRep(), vbId, SUM (tmp.StartRemains))
                   , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReportCollation_EndRemainsRep(), vbId, SUM (tmp.EndRemains))
             FROM gpReport_JuridicalCollation(inStartDate:=inStartDate, inEndDate:=inEndDate, inJuridicalId:=inJuridicalId, inPartnerId:=inPartnerId, inContractId:=inContractId, inAccountId := 0, inPaidKindId:=inPaidKindId, InInfoMoneyId := InInfoMoneyId, inCurrencyId := 0, inMovementId_Partion := 0, inSession:=inSession) AS tmp;

             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Insert(), vbId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportCollation_Insert(), vbId, vbUserId);




             -- перенумеровываем начиная со "следующего"
             /*UPDATE Object SET ObjectCode = COALESCE (vbCode_old, 0) + tmp.Ord + 1
             FROM (SELECT Object_ReportCollation.Id
                        , ROW_NUMBER() OVER (PARTITION BY COALESCE (ObjectLink_ReportCollation_PaidKind.ChildObjectId , 0)
                                                        , COALESCE (ObjectLink_ReportCollation_Contract.ChildObjectId, 0)
                                                        , COALESCE (ObjectLink_ReportCollation_Partner.ChildObjectId, 0)
                                                        , COALESCE (ObjectLink_ReportCollation_Juridical.ChildObjectId, 0)

                                             ORDER BY ObjectDate_Start.ValueData ASC
                                                    , ObjectDate_Start.ObjectId ASC
                                            ) AS Ord
                   FROM ObjectDate AS ObjectDate_Start
                        INNER JOIN Object AS Object_ReportCollation ON Object_ReportCollation.Id = ObjectDate_Start.ObjectId
                                                                   AND Object_ReportCollation.isErased = FALSE
                        INNER JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                                             ON ObjectLink_ReportCollation_PaidKind.ObjectId = ObjectDate_Start.ObjectId
                                            AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()
                                            AND (ObjectLink_ReportCollation_PaidKind.ChildObjectId = COALESCE (inPaidKindId,0) OR COALESCE (inPaidKindId,0)=0)

                        INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                                              ON ObjectLink_ReportCollation_Juridical.ObjectId = ObjectDate_Start.ObjectId
                                             AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()
                                             AND (ObjectLink_ReportCollation_Juridical.ChildObjectId = COALESCE (inJuridicalId,0) OR COALESCE (inJuridicalId,0)=0)

                        INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                                              ON ObjectLink_ReportCollation_Partner.ObjectId = ObjectDate_Start.ObjectId
                                             AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()
                                             AND (ObjectLink_ReportCollation_Partner.ChildObjectId = COALESCE (inPartnerId,0) OR COALESCE (inPartnerId,0)=0)

                        INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                                              ON ObjectLink_ReportCollation_Contract.ObjectId = ObjectDate_Start.ObjectId
                                             AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()
                                             AND (ObjectLink_ReportCollation_Contract.ChildObjectId = COALESCE (inContractId,0) OR COALESCE (inContractId,0)=0)
                   WHERE ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
                     AND ObjectDate_Start.ValueData > inStartDate
                  ) AS tmp
             WHERE tmp.Id = Object.Id;*/

         END IF;

         IF inIsUpdate = TRUE
         THEN
             PERFORM gpUpdate_Object_ReportCollation (inBarCode:= (SELECT zfFormat_BarCode (zc_BarCodePref_Object(), vbId) || '0')
                                                    , inSession:= inSession
                                                     );
         END IF;


         -- сохранили протокол
         PERFORM lpInsert_ObjectProtocol (inObjectId:= vbId, inUserId:= vbUserId, inIsUpdate:= inIsUpdate);

         -- Результат
       --outBarCode := (SELECT zfFormat_BarCode (zc_BarCodePref_Object(), vbId) || '0');
         outBarCode := (SELECT zfFormat_BarCode (zc_BarCodePref_Object(), vbId) || '');

   END IF;


END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.11.18         * add inInfoMoneyId
 14.10.18         *
 20.01.17         *
*/
