-- Function: gpInsert_Object_Partner1CLink (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_Partner1CLink (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_Partner1CLink(
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
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_Object_Partner1CLink());
   vbUserId := lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inBranchTopId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлен <Филиал>.';
   END IF;

   --
   CREATE TEMP TABLE _tmp (Id Integer) ON COMMIT DROP;


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


   -- сохраняем всех
   WITH tmpSale1C  AS (SELECT Sale1C.ClientCode, Sale1C.ClientName, TRIM (Sale1C.ClientOKPO) AS OKPO, CASE WHEN LENGTH (TRIM (Sale1C.ClientOKPO)) > 6 THEN FALSE ELSE TRUE END isOKPO_Virtual
                       FROM Sale1C
                       WHERE zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc)) = inBranchTopId
                         AND Sale1C.ClientCode <> 0
                       GROUP BY Sale1C.ClientCode, Sale1C.ClientName, TRIM (Sale1C.ClientOKPO)
                      )
   INSERT INTO _tmp (Id)
   SELECT lpInsertUpdate_Object_Partner1CLink (inId         := 0
                                             , inCode       := Sale1C.ClientCode
                                             , inName       := Sale1C.ClientName
                                             , inPartnerId  := NULL
                                             , inBranchId   := inBranchTopId
                                             , inContractId := NULL
                                             , inUserId     := vbUserId)
   FROM (SELECT CASE WHEN tmpSale1C.isOKPO_Virtual = FALSE
                      AND ViewHistory_JuridicalDetails.OKPO IS NULL
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
              , 
         FROM tmpSale1C
              LEFT JOIN (SELECT MAX (ObjectHistory_JuridicalDetails_View.JuridicalId) AS JuridicalId, ObjectHistory_JuridicalDetails_View.OKPO
                         FROM ObjectHistory_JuridicalDetails_View
                         GROUP BY ObjectHistory_JuridicalDetails_View.OKPO
                        ) AS ViewHistory_JuridicalDetails ON ViewHistory_JuridicalDetails.OKPO = tmpSale1C.OKPO
                                                         AND tmpSale1C.isOKPO_Virtual = FALSE
        ) AS tmpJuridical

        LEFT JOIN (SELECT Object_Partner1CLink.ObjectCode
                        , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                   FROM Object AS Object_Partner1CLink
                        LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                             ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                            AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                   WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                     AND Object_Partner1CLink.ObjectCode <> 0
                  ) AS tmpPartner1CLink ON tmpPartner1CLink.BranchId = inBranchTopId
                                       AND tmpPartner1CLink.ObjectCode = Sale1C.ClientCode
   WHERE tmpPartner1CLink.ObjectCode IS NULL;
                                          


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsert_Object_Partner1CLink (Integer, TVarChar)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.08.14                                        *
*/
