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
             , isErased         Boolean  -- Удаленный ли элемент
              )
AS
$BODY$
   DECLARE vbPersonalId Integer;
   DECLARE vbMemberId   Integer;
BEGIN
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
                                 -- если inSession = testm
                                 SELECT * FROM
                                (SELECT OL.ObjectId AS PartnerId
                                 FROM ObjectLink AS OL
                                 WHERE OL.ChildObjectId = 344877 -- Альфа 641 ТОВ
                                   AND OL.DescId        = zc_ObjectLink_Partner_Juridical()
                                   AND inSession        IN ('1123966', '5')
                                 LIMIT 1) AS tmp
                                )
                , tmpIsErased AS (SELECT FALSE AS isErased UNION SELECT inIsErased AS isErased)

             -- Результат
             SELECT Object_Partner.Id
                  , Object_Partner.ObjectCode
                  , Object_Partner.ValueData
                  , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, 0)::Integer AS JuridicalId
                  , Object_Partner.isErased 
             FROM tmpPartner
                  JOIN Object AS Object_Partner
                              ON Object_Partner.Id = tmpPartner.PartnerId
                             AND Object_Partner.DescId = zc_Object_Partner() 
                  JOIN tmpIsErased ON tmpIsErased.isErased = Object_Partner.isErased
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = tmpPartner.PartnerId
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical();
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
