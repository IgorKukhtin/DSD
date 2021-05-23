-- Function: lfSelectMobile_Object_Partner (Boolean, TVarChar)

DROP FUNCTION IF EXISTS lfSelectMobile_Object_Partner (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION lfSelectMobile_Object_Partner (
    IN inIsErased Boolean,
    IN inSession  TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer
             , ObjectCode       Integer  -- Код
             , ValueData        TVarChar -- Название
             , JuridicalId      Integer  -- Юридическое лицо
             , isOperDateOrder  Boolean  -- цена по дате заявки, в момент переоценки цены продажи - некоторым ТТ отгрузка происходит по дате заявки, т.е. по старым ценам, а некоторым ТТ на дату когда приедет к покупателю, т.е. по новым ценам
             , PrepareDayCount  TFloat   -- За сколько дней принимается заказ
             , DocumentDayCount TFloat   -- Через сколько дней оформляется документально, возможно понадобится рассчитать дату когда приедет покупателю
             , isErased         Boolean  -- Удаленный ли элемент
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbMemberId   Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- Определяем сотрудника для пользователя
      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));
      -- Определяем
      vbMemberId:= (SELECT OL.ChildObjectId AS MemberId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPersonalId AND OL.DescId   = zc_ObjectLink_Personal_Member());

      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
           RETURN QUERY
             WITH tmpPersonal AS (SELECT OL.ObjectId AS PersonalId
                                  FROM ObjectLink AS OL
                                  WHERE OL.ChildObjectId = vbMemberId
                                    AND OL.DescId        = zc_ObjectLink_Personal_Member()
                                 )
                , tmpPartner AS (-- если vbPersonalId - Сотрудник (торговый)
                                 SELECT OL.ObjectId AS PartnerId
                                 FROM ObjectLink AS OL
                                 WHERE OL.ChildObjectId IN (SELECT tmpPersonal.PersonalId FROM tmpPersonal)
                                   AND OL.DescId        = zc_ObjectLink_Partner_PersonalTrade()
                                 UNION
                                 -- если vbPersonalId - Сотрудник (супервайзер)
                                 SELECT OL.ObjectId AS PartnerId
                                 FROM ObjectLink AS OL
                                 WHERE OL.ChildObjectId IN (SELECT tmpPersonal.PersonalId FROM tmpPersonal)
                                   AND OL.DescId        = zc_ObjectLink_Partner_Personal()
                                 UNION
                                 -- если vbPersonalId - Сотрудник (мерчандайзер)
                                 SELECT OL.ObjectId AS PartnerId
                                 FROM ObjectLink AS OL
                                 WHERE OL.ChildObjectId IN (SELECT tmpPersonal.PersonalId FROM tmpPersonal)
                                   AND OL.DescId        = zc_ObjectLink_Partner_PersonalMerch()
                                 UNION
                                 -- если vbUserId = testm
                                 SELECT * FROM
                                (SELECT OL.ObjectId AS PartnerId
                                 FROM ObjectLink AS OL
                                 WHERE OL.ChildObjectId = 344877 -- Альфа 641 ТОВ
                                   AND OL.DescId        = zc_ObjectLink_Partner_Juridical()
                                   AND vbUserId        IN (1123966, 5)
                                 LIMIT 1) AS tmp
                                )
                , tmpIsErased AS (SELECT FALSE AS isErased UNION SELECT inIsErased AS isErased)

             -- Результат
             SELECT Object_Partner.Id
                  , Object_Partner.ObjectCode
                  , Object_Partner.ValueData
                  , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, 0)::Integer AS JuridicalId

                  , COALESCE (ObjectBoolean_Retail_OperDateOrder.ValueData, FALSE) :: Boolean AS isOperDateOrder
                  , COALESCE (ObjectFloat_Partner_PrepareDayCount.ValueData, 0.0)  :: TFloat  AS PrepareDayCount
                  , COALESCE (ObjectFloat_Partner_DocumentDayCount.ValueData, 0.0) :: TFloat  AS DocumentDayCount
                  , Object_Partner.isErased 
             FROM tmpPartner
                  JOIN Object AS Object_Partner
                              ON Object_Partner.Id = tmpPartner.PartnerId
                             AND Object_Partner.DescId = zc_Object_Partner() 
                  JOIN tmpIsErased ON tmpIsErased.isErased = Object_Partner.isErased
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = tmpPartner.PartnerId
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_PrepareDayCount
                                        ON ObjectFloat_Partner_PrepareDayCount.ObjectId = tmpPartner.PartnerId
                                       AND ObjectFloat_Partner_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_DocumentDayCount
                                        ON ObjectFloat_Partner_DocumentDayCount.ObjectId = tmpPartner.PartnerId
                                       AND ObjectFloat_Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

                  LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                      AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Retail_OperDateOrder
                                          ON ObjectBoolean_Retail_OperDateOrder.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                         AND ObjectBoolean_Retail_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()
                 ;

      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 14.06.17                                                        *
*/

-- тест
-- SELECT * FROM lfSelectMobile_Object_Partner (inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
