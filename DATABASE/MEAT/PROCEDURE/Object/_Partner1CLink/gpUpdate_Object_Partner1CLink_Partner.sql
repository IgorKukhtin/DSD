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



   --
   CREATE TEMP TABLE _tmp (Id Integer) ON COMMIT DROP;



   -- сохраняем всех
   WITH tmpSale1C  AS (SELECT Sale1C.ClientCode, MAX (TRIM (Sale1C.ClientName)) AS ClientName, MAX (TRIM (Sale1C.ClientOKPO)) AS OKPO, CASE WHEN LENGTH (MAX (TRIM (Sale1C.ClientOKPO))) <= 6 THEN TRUE ELSE FALSE END isOKPO_Virtual
                       FROM Sale1C
                       WHERE zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zc_Enum_PaidKind_SecondForm()) = inBranchTopId
                         AND zfGetPaidKindFrom1CType (Sale1C.VidDoc) = zc_Enum_PaidKind_SecondForm()
                         AND Sale1C.ClientCode <> 0
                         AND TRIM (Sale1C.ClientOKPO) <> ''
                       GROUP BY Sale1C.ClientCode
                      )
      , tmpPartner1CLink AS (SELECT MAX (Object_Partner1CLink.Id) AS Id
                                  , Object_Partner1CLink.ObjectCode AS ClientCode
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

   INSERT INTO _tmp (Id)
   SELECT lpInsertUpdate_Object_Partner1CLink (inId         := tmpPartner.Partner1CLinkId
                                             , inCode       := tmpPartner.ClientCode
                                             , inName       := tmpPartner.ClientName
                                             , inPartnerId  := tmpPartner.PartnerId
                                             , inBranchId   := inBranchTopId
                                             , inContractId := tmpPartner.ContractId
                                             , inUserId     := vbUserId)
   FROM 
         -- Контрагент
        (SELECT gpInsertUpdate_Object_Partner(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
   OUT outPartnerName        TVarChar  ,    -- 
    IN inAddress             TVarChar  ,    -- 
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
    IN inShortName           TVarChar  ,    -- краткое наименование
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inHouseNumber         TVarChar  ,    -- Номер дома
    IN inCaseNumber          TVarChar  ,    -- Номер корпуса
    IN inRoomNumber          TVarChar  ,    -- Номер квартиры
    IN inStreetId            Integer   ,    -- Улица/проспект  
    IN inPrepareDayCount     TFloat    ,    -- За сколько дней принимается заказ
    IN inDocumentDayCount    TFloat    ,    -- Через сколько дней оформляется документально
    IN inJuridicalId         Integer   ,    -- Юридическое лицо
    IN inRouteId             Integer   ,    -- Маршрут
    IN inRouteSortingId      Integer   ,    -- Сортировка маршрутов
    IN inPersonalTakeId      Integer   ,    -- Сотрудник (экспедитор) 
    
    IN inPriceListId         Integer   ,    -- Прайс-лист
    IN inPriceListPromoId    Integer   ,    -- Прайс-лист(Акционный)
    IN inStartPromo          TDateTime ,    -- Дата начала акции
    IN inEndPromo            TDateTime ,    -- Дата окончания акции     
              , tmpContract.JuridicalId
              , tmpContract.Partner1CLinkId
              , tmpContract.ClientCode
              , tmpContract.ClientName
              , tmpContract.ContractId
         FROM
         -- Договор
        (SELECT CASE WHEN COALESCE (Contract_noClose.ContractId, COALESCE (Contract_Close.ContractId, COALESCE (Contract_Erased.ContractId, 0))) = 0
                          THEN gpInsertUpdate_Object_Contract (ioId                 := 0
                                                             , inCode               := 0
                                                             , inInvNumber          := 'нет договора'
                                                             , inInvNumberArchive   := ''
                                                             , inComment            := ''
                                                             , inBankAccountExternal:= ''
    
                                                             , inSigningDate        := '01.01.2000'
                                                             , inStartDate          := '01.01.2000'
                                                             , inEndDate            := '31.12.2020'
    
                                                             , inJuridicalId        := tmpJuridical.JuridicalId
                                                             , inJuridicalBasisId   := zc_Juridical_Basis()
                                                             , inInfoMoneyId        := zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                             , inContractKindId     := NULL
                                                             , inPaidKindId         := zc_Enum_PaidKind_SecondForm()
    
                                                             , inPersonalId         := NULL
                                                             , inPersonalTradeId    := NULL
                                                             , inPersonalCollationId:= NULL
                                                             , inBankAccountId      := NULL
                                                             , inContractTagId      := 113113 -- Прямой
    
                                                             , inAreaId             := NULL
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

              , tmpJuridical.JuridicalId
              , tmpJuridical.Partner1CLinkId
              , tmpJuridical.ClientCode
              , tmpJuridical.ClientName
         FROM
         -- Юр.Лицо
        (SELECT CASE WHEN ViewHistory_JuridicalDetails.OKPO IS NULL
                          THEN gpInsertUpdate_Object_Juridical (ioId              := 0
                                                              , inCode            := 0
                                                              , inName            := tmpSale1C.ClientName
                                                              , inGLNCode         := NULL
                                                              , inisCorporate     := FALSE
                                                              , inJuridicalGroupId:= vbJuridicalGroupId
                                                              , inGoodsPropertyId := NULL
                                                              , inRetailId        := NULL
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
              , tmpPartner1CLink.Id AS Partner1CLinkId
              , tmpSale1C.ClientCode
              , tmpSale1C.ClientName

         FROM tmpPartner1CLink
              INNER JOIN tmpSale1C ON tmpSale1C.ClientCode = tmpPartner1CLink.ClientCode
              LEFT JOIN (SELECT MAX (ObjectHistory_JuridicalDetails_View.JuridicalId) AS JuridicalId, ObjectHistory_JuridicalDetails_View.OKPO
                         FROM ObjectHistory_JuridicalDetails_View
                         GROUP BY ObjectHistory_JuridicalDetails_View.OKPO
                        ) AS ViewHistory_JuridicalDetails ON ViewHistory_JuridicalDetails.OKPO = tmpSale1C.OKPO
                                                         AND tmpSale1C.isOKPO_Virtual = FALSE
        ) AS tmpJuridical -- Юр.Лицо
        LEFT JOIN (SELECT MAX (Object_Contract_InvNumber_View.ContractId) AS ContractId, Object_Contract_InvNumber_View.JuridicalId
                   FROM Object_Contract_InvNumber_View
                   WHERE Object_Contract_InvNumber_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                     AND Object_Contract_InvNumber_View.isErased = FALSE
                     AND Object_Contract_InvNumber_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                   GROUP BY Object_Contract_InvNumber_View.JuridicalId
                  ) AS Contract_noClose ON Contract_noClose.JuridicalId = tmpJuridical.JuridicalId
                                       AND tmpJuridical.isJuridicalInsert = FALSE
        LEFT JOIN (SELECT MAX (Object_Contract_InvNumber_View.ContractId) AS ContractId, Object_Contract_InvNumber_View.JuridicalId
                   FROM Object_Contract_InvNumber_View
                   WHERE Object_Contract_InvNumber_View.ContractStateKindId = zc_Enum_ContractStateKind_Close()
                     AND Object_Contract_InvNumber_View.isErased = FALSE
                     AND Object_Contract_InvNumber_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                   GROUP BY Object_Contract_InvNumber_View.JuridicalId
                  ) AS Contract_Close ON Contract_Close.JuridicalId = tmpJuridical.JuridicalId
                                     AND tmpJuridical.isJuridicalInsert = FALSE
                                     AND Contract_noClose.JuridicalId IS NULL
        LEFT JOIN (SELECT MAX (Object_Contract_InvNumber_View.ContractId) AS ContractId, Object_Contract_InvNumber_View.JuridicalId
                   FROM Object_Contract_InvNumber_View
                   WHERE Object_Contract_InvNumber_View.isErased = TRUE
                     AND Object_Contract_InvNumber_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                   GROUP BY Object_Contract_InvNumber_View.JuridicalId
                  ) AS Contract_Erased ON Contract_Erased.JuridicalId = tmpJuridical.JuridicalId
                                      AND tmpJuridical.isJuridicalInsert = FALSE
                                      AND Contract_noClose.JuridicalId IS NULL
                                      AND Contract_Close.JuridicalId IS NULL
        ) AS tmpContract -- Договор
        ) AS tmpPartner -- Контрагент
  ;
                                          


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Partner1CLink_Partner (Integer, TVarChar)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.08.14                                        *
*/
