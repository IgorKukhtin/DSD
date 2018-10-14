-- Function: gpInsert_Object_ReportCollation(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

-- DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat,TFloat,TFloat Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_ReportCollation(
    IN inStartDate           TDateTime,    --
    IN inEndDate             TDateTime,    --
    IN inJuridicalId         Integer,      --
    IN inPartnerId           Integer,      --
    IN inContractId          Integer,      --
    IN inPaidKindId          Integer,      --
    IN inAccountId           Integer,      --
    IN InInfoMoneyId         Integer,      --
    IN inCurrencyId          Integer,      --
    IN inMovementId_Partion  Integer,      --
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
  DECLARE vbCode_old Integer;
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


       -- поиск существующего акта сверки: период, юр.лицо, контрагент, договор, форма оплаты
       vbId:= (SELECT ObjectDate_Start.ObjectId
               FROM ObjectDate AS ObjectDate_Start
                  INNER JOIN ObjectDate AS ObjectDate_End 
                                        ON ObjectDate_End.ObjectId  = ObjectDate_Start.ObjectId
                                       AND ObjectDate_End.DescId    = zc_ObjectDate_ReportCollation_End()
                                       AND ObjectDate_End.ValueData = inEndDate

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
                AND ObjectDate_Start.ValueData= inStartDate
             );
             
         IF inIsUpdate = TRUE AND COALESCE (vbId, 0) = 0
         THEN
              RAISE EXCEPTION 'Ошибка.Виза <Сдали в бухгалтерию> ставится после <Печать для реестра Акты сверок>';
         END IF;


         -- поиск "предыдущего" №п/п
         vbCode_old:= (SELECT MAX (Object_ReportCollation.ObjectCode)
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
                     );


         IF COALESCE (vbId, 0) = 0 OR inIsUpdate = FALSE
         THEN
             -- сохранили <Объект>
             vbId := lpInsertUpdate_Object( COALESCE (vbId, 0), zc_Object_ReportCollation(), COALESCE (vbCode_old, 0) + 1, '');
    
             --
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Juridical(), vbId, COALESCE (inJuridicalId,0));
             --
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Partner(), vbId, COALESCE (inPartnerId,0));
             --
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Contract(), vbId, COALESCE (inContractId,0));
             --
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_PaidKind(), vbId, COALESCE (inPaidKindId,0));
    
             -- сохранили свойство <Дата начала периода>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Start(), vbId, inStartDate);
             -- сохранили свойство <Дата окончания периода>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_End(), vbId, inEndDate);


             -- сохранили свойства <>
             PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReportCollation_StartRemainsRep(), vbId, tmp.StartRemains)
                   , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReportCollation_EndRemainsRep(), vbId, tmp.EndRemains)
             FROM gpReport_JuridicalCollation(inStartDate, inEndDate, inJuridicalId, inPartnerId, inContractId, inAccountId, inPaidKindId, InInfoMoneyId, inCurrencyId, inMovementId_Partion, inSession) AS tmp;

             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Insert(), vbId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportCollation_Insert(), vbId, vbUserId);
          


        
             -- перенумеровываем начиная со "следующего"
             UPDATE Object SET ObjectCode = COALESCE (vbCode_old, 0) + tmp.Ord + 1
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
             WHERE tmp.Id = Object.Id;
         END IF;

         IF inIsUpdate = TRUE
         THEN
             PERFORM gpUpdate_Object_ReportCollation (inBarCode:= (SELECT zfFormat_BarCode (zc_BarCodePref_Object(), vbId))
                                                    , inSession:= inSession
                                                     );
         END IF;


   END IF;

   -- Результат
   outBarCode := (SELECT zfFormat_BarCode (zc_BarCodePref_Object(), vbId));

  
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.10.18         *
 20.01.17         *

*/
