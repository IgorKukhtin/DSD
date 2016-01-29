-- Function: gpUpdate_Object_Partner1CLink_Partner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner1CLink_Partner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner1CLink_Partner(
    IN inBranchTopId            Integer,    -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalGroupId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner1CLink_Partner());
   vbUserId := lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inBranchTopId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлен <Филиал>.';
   END IF;

   -- определяется группа
   vbJuridicalGroupId:= (SELECT Object_JuridicalGroup.Id
                         FROM Object
                              INNER JOIN Object AS Object_JuridicalGroup
                                                ON Object_JuridicalGroup.DescId = zc_Object_JuridicalGroup()
                                               AND Object_JuridicalGroup.ObjectCode = 20 + Object.ObjectCode
                         WHERE Object.Id = inBranchTopId);

   -- проверка
   IF COALESCE (vbJuridicalGroupId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не определена <Группа Юр.лиц>.';
   END IF;


   -- эта табл - "не используется"
   CREATE TEMP TABLE _tmp (Id Integer) ON COMMIT DROP;

   -- 1. сохранение новых
   WITH tmpSale1C  AS (SELECT ClientCode, ClientName
                            --, OKPO
                            --, CASE WHEN LENGTH (OKPO) <= 5 THEN TRUE ELSE FALSE END isOKPO_Virtual
                            , CASE WHEN LENGTH (OKPO) - LENGTH (OKPO_calc) > 3 THEN OKPO ELSE OKPO_calc END AS OKPO
                            , CASE WHEN LENGTH (CASE WHEN LENGTH (OKPO) - LENGTH (OKPO_calc) > 3 THEN OKPO ELSE OKPO_calc END) <= 5 THEN TRUE ELSE FALSE END isOKPO_Virtual
                       FROM
                      (SELECT ClientCode, ClientName
                            , OKPO
                            , CASE WHEN OKPO <> '' THEN (zfConvert_ViewWorkHourToHour (OKPO) :: BIGINT) :: TVarChar ELSE OKPO END AS OKPO_calc
                       FROM
                      (SELECT Sale1C.ClientCode, MAX (TRIM (Sale1C.ClientName)) AS ClientName
                            , MAX (CASE WHEN TRIM (Sale1C.ClientOKPO) <> '' THEN TRIM (Sale1C.ClientOKPO) WHEN TRIM (Sale1C.ClientOKPO) = '' AND TRIM (Sale1C.ClientINN) = '' THEN '01*01' ELSE TRIM (Sale1C.ClientINN) END) AS OKPO
                       FROM Sale1C
                       WHERE zfGetBranchLinkFromBranchPaidKind (zfGetBranchFromUnitId (Sale1C.UnitId), zc_Enum_PaidKind_SecondForm()) = inBranchTopId
                         AND zfGetPaidKindFrom1CType (Sale1C.VidDoc) = zc_Enum_PaidKind_SecondForm()
                         AND Sale1C.ClientCode <> 0
                         -- !!!потом вернуть!!!
                         AND (TRIM (Sale1C.ClientOKPO) <> '' OR TRIM (Sale1C.ClientINN) <> '')
                         AND LENGTH (TRIM (Sale1C.ClientOKPO)) >= 5
                       GROUP BY Sale1C.ClientCode
                      ) AS tmp
                      ) AS tmp
                      )
      , tmpPartner1CLink AS (SELECT MAX (Object_Partner1CLink.Id) AS Id
                                  , Object_Partner1CLink.ObjectCode AS ClientCode
                                  , MAX (ObjectLink_Partner1CLink_Partner.ChildObjectId) AS PartnerId
                             FROM Object AS Object_Partner1CLink
                                  INNER JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                                        ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                                       AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                                                       AND ObjectLink_Partner1CLink_Branch.ChildObjectId = inBranchTopId
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                                       ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                                      AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
                             WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                               AND Object_Partner1CLink.ObjectCode <> 0
                               AND ObjectLink_Partner1CLink_Partner.ChildObjectId IS NULL
                             GROUP BY Object_Partner1CLink.ObjectCode
                            )
      , tmpAll AS (SELECT tmpPartner1CLink.Id AS Partner1CLinkId, COALESCE (tmpPartner1CLink.PartnerId, 0) AS PartnerId, tmpPartner1CLink.ClientCode
                        , tmpSale1C.ClientName, tmpSale1C.OKPO, tmpSale1C.isOKPO_Virtual
                   FROM tmpPartner1CLink
                        INNER JOIN tmpSale1C ON tmpSale1C.ClientCode = tmpPartner1CLink.ClientCode
                  )
      , tmpJuridical AS (SELECT tmpAll.OKPO, tmpAll.isOKPO_Virtual, CASE WHEN tmpAll.isOKPO_Virtual = TRUE THEN tmpAll.ClientCode ELSE 0 END AS ClientCode, MAX (tmpAll.ClientName) AS JuridicalName
                         FROM tmpAll
                         GROUP BY tmpAll.OKPO, tmpAll.isOKPO_Virtual, CASE WHEN tmpAll.isOKPO_Virtual = TRUE THEN tmpAll.ClientCode ELSE 0 END
                        )
   INSERT INTO _tmp (Id)
   SELECT -- сохранение связи с 1С
          lpInsertUpdate_Object_Partner1CLink (ioId         := tmpPartner.Partner1CLinkId
                                             , inCode       := tmpPartner.ClientCode
                                             , inName       := tmpPartner.ClientName
                                             , inPartnerId  := tmpPartner.PartnerId
                                             , inBranchId   := inBranchTopId
                                             , inContractId := tmpPartner.ContractId
                                             , inUserId     := vbUserId)
   FROM 
         -- сохранение Контрагента
        (SELECT lpInsertUpdate_Object_Partner_by1C (ioId          := tmpAll.PartnerId
                                                  , inCode        := 0
                                                  , inName        := tmpAll.ClientName
                                                  , inJuridicalId := tmpContract.JuridicalId
                                                  , inUserId      := vbUserId
                                                   ) AS PartnerId
              , tmpContract.JuridicalId
              , tmpContract.ContractId
              , tmpAll.Partner1CLinkId
              , tmpAll.ClientCode
              , tmpAll.ClientName
         FROM
         -- сохранение Договора
        (SELECT CASE WHEN COALESCE (Contract_noClose.ContractId, COALESCE (Contract_Close.ContractId, COALESCE (Contract_Erased.ContractId, 0))) = 0
                          THEN gpInsertUpdate_Object_Contract (ioId                 := 0
                                                             , inCode               := 0
                                                             , inInvNumber          := 'без договора'
                                                             , inInvNumberArchive   := ''
                                                             , inComment            := ''
                                                             , inBankAccountExternal:= ''
                                                             , inGLNCode            := ''

                                                             , inSigningDate        := '01.01.2000'
                                                             , inStartDate          := '01.01.2000'
                                                             , inEndDate            := '31.12.2020'
    
                                                             , inJuridicalId        := tmpJuridical.JuridicalId
                                                             , inJuridicalBasisId   := zc_Juridical_Basis()
                                                             , inJuridicalDocumentId := NULL
                                                             , inInfoMoneyId        := zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                             , inContractKindId     := NULL
                                                             , inPaidKindId         := zc_Enum_PaidKind_SecondForm()
    
                                                             , inPersonalId         := NULL
                                                             , inPersonalTradeId    := NULL
                                                             , inPersonalCollationId:= NULL
                                                             , inBankAccountId      := NULL
                                                             , inContractTagId      := 113113 -- Прямой
    
                                                             , inAreaContractId     := NULL
                                                             , inContractArticleId  := NULL
                                                             , inContractStateKindId:= NULL
                                                             , inBankId             := NULL
                                                             , inisDefault          := TRUE
                                                             , inisStandart         := TRUE

                                                             , inisPersonal         := FALSE
                                                             , inisUnique           := TRUE
                                                             , inSession            := inSession
                                                               )
                     ELSE COALESCE (Contract_noClose.ContractId, COALESCE (Contract_Close.ContractId, COALESCE (Contract_Erased.ContractId, 0)))
                END AS ContractId

              , tmpJuridical.OKPO
              , tmpJuridical.ClientCode
              , tmpJuridical.JuridicalId
         FROM
         -- сохранение Юр.Лица
        (SELECT CASE WHEN ViewHistory_JuridicalDetails.OKPO IS NULL
                          THEN gpInsertUpdate_Object_Juridical (ioId              := 0
                                                              , inCode            := 0
                                                              , inName            := tmpJuridical.JuridicalName
                                                              , inGLNCode         := NULL
                                                              , inisCorporate     := FALSE
                                                              , inisTaxSummary     := NULL
                                                              , inisDiscountPrice  := NULL
                                                              , inDayTaxSummary    := 0
                                                              , inJuridicalGroupId:= vbJuridicalGroupId
                                                              , inGoodsPropertyId := NULL
                                                              , inRetailId        := NULL
                                                              , inRetailReportId  := NULL
                                                              , inInfoMoneyId     := zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                              , inPriceListId     := NULL
                                                              , inPriceListPromoId:= NULL
                                                              , inStartPromo      := NULL
                                                              , inEndPromo        := NULL
                                                              , inSession         := inSession
                                                               )
                     ELSE COALESCE (ViewHistory_JuridicalDetails.JuridicalId, 0)
                END AS JuridicalId

              , CASE WHEN ViewHistory_JuridicalDetails.OKPO IS NULL THEN TRUE ELSE FALSE END AS isJuridicalInsert
              , tmpJuridical.OKPO
              , tmpJuridical.ClientCode
         FROM tmpJuridical
              LEFT JOIN (SELECT MAX (ObjectHistory_JuridicalDetails_View.JuridicalId) AS JuridicalId, ObjectHistory_JuridicalDetails_View.OKPO
                         FROM ObjectHistory_JuridicalDetails_View
                         GROUP BY ObjectHistory_JuridicalDetails_View.OKPO
                        ) AS ViewHistory_JuridicalDetails ON ViewHistory_JuridicalDetails.OKPO = tmpJuridical.OKPO
                                                         AND tmpJuridical.isOKPO_Virtual = FALSE
        ) AS tmpJuridical -- Юр.Лицо
        LEFT JOIN (SELECT MAX (Object_Contract_View.ContractId) AS ContractId, Object_Contract_View.JuridicalId
                   FROM Object_Contract_View
                   WHERE Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                     AND Object_Contract_View.isErased = FALSE
                     AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                   GROUP BY Object_Contract_View.JuridicalId
                  ) AS Contract_noClose ON Contract_noClose.JuridicalId = tmpJuridical.JuridicalId
                                       AND tmpJuridical.isJuridicalInsert = FALSE
        LEFT JOIN (SELECT MAX (Object_Contract_View.ContractId) AS ContractId, Object_Contract_View.JuridicalId
                   FROM Object_Contract_View
                   WHERE Object_Contract_View.ContractStateKindId = zc_Enum_ContractStateKind_Close()
                     AND Object_Contract_View.isErased = FALSE
                     AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                   GROUP BY Object_Contract_View.JuridicalId
                  ) AS Contract_Close ON Contract_Close.JuridicalId = tmpJuridical.JuridicalId
                                     AND tmpJuridical.isJuridicalInsert = FALSE
                                     AND Contract_noClose.JuridicalId IS NULL
        LEFT JOIN (SELECT MAX (Object_Contract_View.ContractId) AS ContractId, Object_Contract_View.JuridicalId
                   FROM Object_Contract_View
                   WHERE Object_Contract_View.isErased = TRUE
                     AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                   GROUP BY Object_Contract_View.JuridicalId
                  ) AS Contract_Erased ON Contract_Erased.JuridicalId = tmpJuridical.JuridicalId
                                      AND tmpJuridical.isJuridicalInsert = FALSE
                                      AND Contract_noClose.JuridicalId IS NULL
                                      AND Contract_Close.JuridicalId IS NULL
        ) AS tmpContract -- Договор
        LEFT JOIN tmpAll ON (tmpAll.OKPO = tmpContract.OKPO AND tmpAll.isOKPO_Virtual = FALSE)
                         OR (tmpAll.ClientCode = tmpContract.ClientCode AND tmpAll.isOKPO_Virtual = TRUE)

        ) AS tmpPartner -- Контрагент
  ;
                                          

   -- 2. сохранение
   WITH tmpSale1C  AS (SELECT JuridicalId
                            --, OKPO
                            , CASE WHEN LENGTH (OKPO) - LENGTH (OKPO_calc) > 3 THEN OKPO ELSE OKPO_calc END AS OKPO
                            , INN
                       FROM
                      (SELECT JuridicalId
                            , OKPO
                            , CASE WHEN OKPO <> '' THEN (zfConvert_ViewWorkHourToHour (OKPO) :: BIGINT) :: TVarChar ELSE OKPO END AS OKPO_calc
                            , INN
                       FROM
                      (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                            , MAX (CASE WHEN TRIM (Sale1C.ClientOKPO) = '' THEN '01*01' ELSE TRIM (Sale1C.ClientOKPO) END) AS OKPO
                            , MAX (TRIM (Sale1C.ClientINN))  AS INN
                       FROM _tmp
                            INNER JOIN Object AS Object_Partner1CLink ON Object_Partner1CLink.Id = _tmp.Id
                            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                                 ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                 ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            INNER JOIN Sale1C ON Sale1C.ClientCode = Object_Partner1CLink.ObjectCode
                                             AND zfGetBranchLinkFromBranchPaidKind (zfGetBranchFromUnitId (Sale1C.UnitId), zc_Enum_PaidKind_SecondForm()) = inBranchTopId
                                             AND zfGetPaidKindFrom1CType (Sale1C.VidDoc) = zc_Enum_PaidKind_SecondForm()
                       GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                      ) AS tmp
                      ) AS tmp
                      )
   INSERT INTO _tmp (Id)
   SELECT -- сохранение реквизитов
          gpInsertUpdate_ObjectHistory_JuridicalDetails (ioId               := 0
                                                       , inJuridicalId      := tmpSale1C.JuridicalId
                                                       , inOperDate         := zc_DateStart()
                                                       , inBankId           := NULL
                                                       , inFullName         := NULL
                                                       , inJuridicalAddress := NULL
                                                       , inOKPO             := tmpSale1C.OKPO
                                                       , inINN	            := tmpSale1C.INN
                                                       , inNumberVAT	    := NULL
                                                       , inAccounterName    := NULL
                                                       , inBankAccount	    := NULL
                                                       , inPhone      	    := NULL
                                                       , inSession          := inSession)
   FROM tmpSale1C
        LEFT JOIN ObjectHistory ON ObjectHistory.ObjectId = tmpSale1C.JuridicalId
                               AND ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
   WHERE ObjectHistory.ObjectId IS NULL;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Partner1CLink_Partner (Integer, TVarChar)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.09.14                                        * add gpInsertUpdate_ObjectHistory_JuridicalDetails
 22.08.14                                        *
*/

/*
"Безсиловська О.О.";"Безсиловська О.О.";"3163220108"
"Дем"яненко Н.П.";"Дем"яненко Н.П.";"1905323222"
"Дяченко Д.А.";"Дяченко Д.А.";"3183512074"
"Заволока 5% Оболонь +";"Заволока 5% Оболонь +";"3112611673"
"Невечеря _.П. Слоб_дська";"Невечеря _.П. Слоб_дська";"2990109880"
"Невечеря _.П. Лозоватка";"Невечеря _.П. Слоб_дська";"2990109880"
"Шульга Н.В.";"Шульга Н.В.";"2064814385"
"Якименко С.М.";"Якименко С.М.";"2340514464"
*/