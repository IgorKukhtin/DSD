-- Function: gpSelect_Object_Partner_Mobile (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Mobile (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Mobile (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Mobile (Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner_Mobile (
    IN inMemberId          Integer  , -- физ.лицо
    IN inRetailId          Integer  ,
    IN inJuridicalId       Integer  ,
    IN inRouteId           Integer  ,
    IN inisShowAll         Boolean  , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id              Integer
             , Code            Integer  -- Код
             , Name            TVarChar -- Название
             , Address         TVarChar -- Адрес точки доставки
             , GPSN            TFloat   -- GPS координаты точки доставки (широта)
             , GPSE            TFloat   -- GPS координаты точки доставки (долгота)
             , Schedule        TVarChar -- График посещения ТТ - по каким дням недели - в строчке 7 символов разделенных ";" t значит true и f значит false
             , Delivery        TVarChar -- График завоза на ТТ - по каким дням недели - в строчке 7 символов разделенных ";" t значит true и f значит false
             , DebtSum         TFloat   -- Сумма долга (нам) - НАЛ - т.к НАЛ долг формируется только в разрезе Контрагентов + договоров + для некоторых по № накладных
             , OverSum         TFloat   -- Сумма просроченного долга (нам) - НАЛ - Просрочка наступает спустя определенное кол-во дней
             , OverDays        Integer  -- Кол-во дней просрочки (нам)
             , PrepareDayCount TFloat   -- За сколько дней принимается заказ
             , PartnerTagName  TVarChar --
             , JuridicalId     Integer  -- Юридическое лицо
             , JuridicalName   TVarChar --
             , RouteId         Integer  -- Маршрут
             , RouteName       TVarChar --
             , RetailId Integer, RetailName TVarChar  -- торговая сеть
             , PaidKindName    TVarChar --
             , ContractId      Integer  -- Договор - все возможные договора...
             , ContractCode    Integer  --
             , ContractName    TVarChar --
             , ContractStateKindCode Integer
             , ContractTagName       TVarChar
             , InfoMoneyName_all     TVarChar
             , PriceListId     Integer  -- Прайс-лист - по каким ценам будет формироваться заказ
             , PriceListName   TVarChar --
             , PriceListId_ret Integer  -- Прайс-лист Возврата - по каким ценам будет формироваться возврат
             , PriceListName_ret TVarChar  --
             , isErased        Boolean  -- Удаленный ли элемент
             , isSync          Boolean  -- Синхронизируется (да/нет)

             , Value1 Boolean, Value2 Boolean, Value3 Boolean, Value4 Boolean
             , Value5 Boolean, Value6 Boolean, Value7 Boolean

             , Delivery1 Boolean, Delivery2 Boolean, Delivery3 Boolean, Delivery4 Boolean
             , Delivery5 Boolean, Delivery6 Boolean, Delivery7 Boolean

             , PersonalName TVarChar
             , BranchName   TVarChar
             , UnitName     TVarChar
             , PositionName TVarChar

             , ContainerId  Integer
              )
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbUserId_Mobile Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!меняем значение!!! - с какими параметрами пользователь может просматривать данные с мобильного устройства
     vbUserId_Mobile:= (SELECT CASE WHEN lfGet.UserId > 0 THEN lfGet.UserId ELSE vbUserId END FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet);


     -- Результат
     RETURN QUERY
          SELECT gpSelect.Id
               , gpSelect.ObjectCode AS Code
               , gpSelect.ValueData  AS Name
               , gpSelect.Address
               , gpSelect.GPSN
               , gpSelect.GPSE
               , gpSelect.Schedule
               , gpSelect.Delivery
               , gpSelect.DebtSum
               , gpSelect.OverSum
               , gpSelect.OverDays
               , gpSelect.PrepareDayCount
               , Object_PartnerTag.ValueData    AS PartnerTagName
               , Object_Juridical.Id            AS JuridicalId
               , Object_Juridical.ValueData     AS JuridicalName
               , Object_Route.Id                AS RouteId
               , Object_Route.ValueData         AS RouteName
               , Object_Retail.Id               AS RetailId
               , Object_Retail.ValueData        AS RetailName
               , Object_PaidKind.ValueData      AS PaidKindName
               , Object_Contract.Id             AS ContractId
               , Object_Contract.ObjectCode     AS ContractCode
               , Object_Contract.ValueData      AS ContractName
               , Object_ContractStateKind.ObjectCode AS ContractStateKindCode
               , Object_ContractTag.ValueData   AS ContractTagName
               , Object_InfoMoney_View.InfoMoneyName_all
               , Object_PriceList.Id            AS PriceListId
               , Object_PriceList.ValueData     AS PriceListName
               , Object_PriceList_Ret.Id        AS PriceListId_ret
               , Object_PriceList_Ret.ValueData AS PriceListName_ret
               , gpSelect.isErased
               , gpSelect.isSync

               , CASE WHEN COALESCE(gpSelect.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Schedule, inSep:= ';', inIndex:= 1) ::Boolean END ::Boolean    AS Value1
               , CASE WHEN COALESCE(gpSelect.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Schedule, inSep:= ';', inIndex:= 2) ::Boolean END ::Boolean    AS Value2
               , CASE WHEN COALESCE(gpSelect.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Schedule, inSep:= ';', inIndex:= 3) ::Boolean END ::Boolean    AS Value3
               , CASE WHEN COALESCE(gpSelect.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Schedule, inSep:= ';', inIndex:= 4) ::Boolean END ::Boolean    AS Value4
               , CASE WHEN COALESCE(gpSelect.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Schedule, inSep:= ';', inIndex:= 5) ::Boolean END ::Boolean    AS Value5
               , CASE WHEN COALESCE(gpSelect.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Schedule, inSep:= ';', inIndex:= 6) ::Boolean END ::Boolean    AS Value6
               , CASE WHEN COALESCE(gpSelect.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Schedule, inSep:= ';', inIndex:= 7) ::Boolean END ::Boolean    AS Value7

               , CASE WHEN COALESCE(gpSelect.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Delivery, inSep:= ';', inIndex:= 1) ::Boolean END ::Boolean    AS Delivery1
               , CASE WHEN COALESCE(gpSelect.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Delivery, inSep:= ';', inIndex:= 2) ::Boolean END ::Boolean    AS Delivery2
               , CASE WHEN COALESCE(gpSelect.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Delivery, inSep:= ';', inIndex:= 3) ::Boolean END ::Boolean    AS Delivery3
               , CASE WHEN COALESCE(gpSelect.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Delivery, inSep:= ';', inIndex:= 4) ::Boolean END ::Boolean    AS Delivery4
               , CASE WHEN COALESCE(gpSelect.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Delivery, inSep:= ';', inIndex:= 5) ::Boolean END ::Boolean    AS Delivery5
               , CASE WHEN COALESCE(gpSelect.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Delivery, inSep:= ';', inIndex:= 6) ::Boolean END ::Boolean    AS Delivery6
               , CASE WHEN COALESCE(gpSelect.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= gpSelect.Delivery, inSep:= ';', inIndex:= 7) ::Boolean END ::Boolean    AS Delivery7

               , Object_PersonalTrade.PersonalName
               , Object_PersonalTrade.BranchName
               , Object_PersonalTrade.UnitName
               , Object_PersonalTrade.PositionName

               , gpSelect.ContainerId

          FROM gpSelectMobile_Object_Partner (zc_DateStart(), vbUserId_Mobile :: TVarChar) AS gpSelect

               LEFT JOIN Object AS Object_Juridical     ON Object_Juridical.Id     = gpSelect.JuridicalId
               LEFT JOIN Object AS Object_Route         ON Object_Route.Id         = gpSelect.RouteId
               LEFT JOIN Object AS Object_PriceList     ON Object_PriceList.Id     = gpSelect.PriceListId
               LEFT JOIN Object AS Object_PriceList_Ret ON Object_PriceList_Ret.Id = gpSelect.PriceListId_ret
               LEFT JOIN Object AS Object_PaidKind      ON Object_PaidKind.Id      = gpSelect.PaidKindId

               LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                                    ON ObjectLink_Partner_PartnerTag.ObjectId = gpSelect.Id
                                   AND ObjectLink_Partner_PartnerTag.DescId   = zc_ObjectLink_Partner_PartnerTag()
               LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId

               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = gpSelect.ContractId
               LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                    ON ObjectLink_Contract_ContractStateKind.ObjectId = Object_Contract.Id
                                   AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind()
               LEFT JOIN Object AS Object_ContractStateKind ON Object_ContractStateKind.Id = ObjectLink_Contract_ContractStateKind.ChildObjectId
               LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                    ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                   AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
               LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                    ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                   AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
               LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                    ON ObjectLink_Partner_PersonalTrade.ObjectId = gpSelect.Id
                                   AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
               LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

          WHERE (gpSelect.isErased                 = inisShowAll        OR inisShowAll   = TRUE)
            AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId    = 0)
            AND (gpSelect.RouteId                  = inRouteId          OR inRouteId     = 0)
            AND (gpSelect.JuridicalId              = inJuridicalId      OR inJuridicalId = 0)
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 05.05.17         *
 07.03.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Partner_Mobile (inMemberId := 274610 , inRetailId := 310847 , inJuridicalId := 140733 , inRouteId := 8548 , inisShowAll := 'False' ,  inSession := '5');
