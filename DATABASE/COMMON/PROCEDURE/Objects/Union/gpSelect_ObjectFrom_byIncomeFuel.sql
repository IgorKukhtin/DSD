-- Function: gpSelect_ObjectFrom_byIncomeFuel()

DROP FUNCTION IF EXISTS gpSelect_ObjectFrom_byIncomeFuel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectFrom_byIncomeFuel(
    IN inSession           TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, 
               isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());

   RETURN QUERY
     SELECT Object_Partner.Id             AS Id
          , Object_Partner.ObjectCode     AS Code
          , Object_Partner.ValueData      AS Name

          , Object_Juridical.ObjectCode   AS JuridicalCode
          , Object_Juridical.ValueData    AS JuridicalName

          , Object_Partner.isErased   AS isErased

     FROM Object_InfoMoney_View
          JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                          ON ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
                         AND ObjectLink_Juridical_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical_InfoMoney.ObjectId

          JOIN ObjectLink AS ObjectLink_Partner_Juridical
                          ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_InfoMoney.ObjectId
                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId

          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId

     WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400() -- ГСМ
    UNION ALL
     SELECT Object_CardFuel.Id             AS Id
          , Object_CardFuel.ObjectCode     AS Code
          , Object_CardFuel.ValueData      AS Name

          , Object_Juridical.ObjectCode   AS JuridicalCode
          , Object_Juridical.ValueData    AS JuridicalName

          , Object_CardFuel.isErased   AS isErased

     FROM Object AS Object_CardFuel
          LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical ON ObjectLink_CardFuel_Juridical.ObjectId = Object_CardFuel.Id
                                                               AND ObjectLink_CardFuel_Juridical.DescId = zc_ObjectLink_CardFuel_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CardFuel_Juridical.ChildObjectId

          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId

     WHERE Object_CardFuel.DescId = zc_Object_CardFuel()

    UNION ALL
     SELECT Object_TicketFuel.Id           AS Id
          , Object_TicketFuel.ObjectCode   AS Code
          , Object_TicketFuel.ValueData    AS Name

          , Object_Juridical.ObjectCode   AS JuridicalCode
          , Object_Juridical.ValueData    AS JuridicalName

          , Object_TicketFuel.isErased   AS isErased

     FROM Object AS Object_TicketFuel
          LEFT JOIN ObjectLink AS ObjectLink_TicketFuel_Goods ON ObjectLink_TicketFuel_Goods.ObjectId = Object_TicketFuel.Id
                                                             AND ObjectLink_TicketFuel_Goods.DescId = zc_ObjectLink_TicketFuel_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_TicketFuel_Goods.ChildObjectId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = zc_Juridical_Basis()
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_TicketFuel.DescId

     WHERE Object_TicketFuel.DescId = zc_Object_TicketFuel()
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ObjectFrom_byIncomeFuel (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectFrom_byIncomeFuel ('2')