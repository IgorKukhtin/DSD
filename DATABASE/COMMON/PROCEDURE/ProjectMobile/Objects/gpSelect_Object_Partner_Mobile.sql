-- Function: gpSelect_Object_Partner_Mobile (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Mobile (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Mobile (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Mobile (Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner_Mobile (
    IN inMemberId          Integer  , -- физ.лицо
    IN inJuridicalId       Integer  , 
    IN inRetailId          Integer  , 
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
             , JuridicalId     Integer  -- Юридическое лицо
             , JuridicalName   TVarChar --
             , RouteId         Integer  -- Маршрут
             , RouteName       TVarChar -- 
             , RetailId Integer, RetailName TVarChar  -- торговая сеть
             , ContractId      Integer  -- Договор - все возможные договора...
             , ContractCode    Integer  --
             , ContractName    TVarChar -- 
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
             , BranchName TVarChar
             , UnitName TVarChar
             , PositionName TVarChar
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
   DECLARE calcSession TVarChar;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);
     
     --vbMemberId:= inMemberId;
     vbMemberId:= (SELECT tmp.MemberId FROM gpGetMobile_Object_Const (inSession) AS tmp);
     IF (COALESCE(inMemberId,0) <> 0 AND COALESCE(vbMemberId,0) <> inMemberId)
        THEN
            RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.'; 
     END IF;

     calcSession := (SELECT CAST (ObjectLink_User_Member.ObjectId AS TVarChar) 
                       FROM ObjectLink AS ObjectLink_User_Member
                       WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                         AND ObjectLink_User_Member.ChildObjectId = vbMemberId);

      RETURN QUERY
          SELECT tmpMobilePartner.Id
               , tmpMobilePartner.ObjectCode AS Code
               , tmpMobilePartner.ValueData  AS Name
               , tmpMobilePartner.Address
               , tmpMobilePartner.GPSN
               , tmpMobilePartner.GPSE
               , tmpMobilePartner.Schedule
               , tmpMobilePartner.Delivery
               , tmpMobilePartner.DebtSum
               , tmpMobilePartner.OverSum
               , tmpMobilePartner.OverDays
               , tmpMobilePartner.PrepareDayCount 
               , Object_Juridical.Id            AS JuridicalId
               , Object_Juridical.ValueData     AS JuridicalName
               , Object_Route.Id                AS RouteId
               , Object_Route.ValueData         AS RouteName
               , Object_Retail.Id               AS RetailId
               , Object_Retail.ValueData        AS RetailName
               , Object_Contract.Id             AS ContractId
               , Object_Contract.ObjectCode     AS ContractCode
               , Object_Contract.ValueData      AS ContractName
               , Object_PriceList.Id            AS PriceListId
               , Object_PriceList.ValueData     AS PriceListName
               , Object_PriceList_Ret.Id        AS PriceListId_ret
               , Object_PriceList_Ret.ValueData AS PriceListName_ret
               , tmpMobilePartner.isErased
               , tmpMobilePartner.isSync

               , CASE WHEN COALESCE(tmpMobilePartner.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 1) ::Boolean END ::Boolean    AS Value1
               , CASE WHEN COALESCE(tmpMobilePartner.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 2) ::Boolean END ::Boolean    AS Value2
               , CASE WHEN COALESCE(tmpMobilePartner.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 3) ::Boolean END ::Boolean    AS Value3
               , CASE WHEN COALESCE(tmpMobilePartner.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 4) ::Boolean END ::Boolean    AS Value4
               , CASE WHEN COALESCE(tmpMobilePartner.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 5) ::Boolean END ::Boolean    AS Value5
               , CASE WHEN COALESCE(tmpMobilePartner.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 6) ::Boolean END ::Boolean    AS Value6
               , CASE WHEN COALESCE(tmpMobilePartner.Schedule,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 7) ::Boolean END ::Boolean    AS Value7

               , CASE WHEN COALESCE(tmpMobilePartner.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Delivery, inSep:= ';', inIndex:= 1) ::Boolean END ::Boolean    AS Delivery1
               , CASE WHEN COALESCE(tmpMobilePartner.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Delivery, inSep:= ';', inIndex:= 2) ::Boolean END ::Boolean    AS Delivery2
               , CASE WHEN COALESCE(tmpMobilePartner.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Delivery, inSep:= ';', inIndex:= 3) ::Boolean END ::Boolean    AS Delivery3
               , CASE WHEN COALESCE(tmpMobilePartner.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Delivery, inSep:= ';', inIndex:= 4) ::Boolean END ::Boolean    AS Delivery4
               , CASE WHEN COALESCE(tmpMobilePartner.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Delivery, inSep:= ';', inIndex:= 5) ::Boolean END ::Boolean    AS Delivery5
               , CASE WHEN COALESCE(tmpMobilePartner.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Delivery, inSep:= ';', inIndex:= 6) ::Boolean END ::Boolean    AS Delivery6
               , CASE WHEN COALESCE(tmpMobilePartner.Delivery,'') = '' THEN FALSE ELSE zfCalc_Word_Split (inValue:= tmpMobilePartner.Delivery, inSep:= ';', inIndex:= 7) ::Boolean END ::Boolean    AS Delivery7

               , Object_PersonalTrade.PersonalName
               , Object_PersonalTrade.BranchName 
               , Object_PersonalTrade.UnitName     
               , Object_PersonalTrade.PositionName 

          FROM gpSelectMobile_Object_Partner (zc_DateStart(), calcSession) AS tmpMobilePartner
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpMobilePartner.JuridicalId 
               LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMobilePartner.RouteId 
               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpMobilePartner.ContractId 
               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpMobilePartner.PriceListId 
               LEFT JOIN Object AS Object_PriceList_Ret ON Object_PriceList_Ret.Id = tmpMobilePartner.PriceListId_ret 

               LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                    ON ObjectLink_Partner_PersonalTrade.ObjectId = tmpMobilePartner.Id
                                   AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
               LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

          WHERE tmpMobilePartner.isSync = TRUE
           AND ( tmpMobilePartner.isErased = inisShowAll OR inisShowAll = True)
           AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
           AND (tmpMobilePartner.RouteId = inRouteId OR inRouteId = 0)
           AND (tmpMobilePartner.JuridicalId = inJuridicalId OR inJuridicalId = 0)
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
-- select * from gpSelect_Object_Partner_Mobile(inMemberId := 274610 , inRetailId := 310847 , inJuridicalId := 140733 , inRouteId := 8548 , inisShowAll := 'False' ,  inSession := '5');
