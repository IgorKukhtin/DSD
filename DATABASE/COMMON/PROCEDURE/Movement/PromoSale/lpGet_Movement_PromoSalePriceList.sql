-- расчет Прайс-лист для документа Акции
-- Function: lpGet_Movement_PromoSalePriceList()

DROP FUNCTION IF EXISTS lpGet_Movement_PromoSalePriceList (Integer, integer);

CREATE OR REPLACE FUNCTION lpGet_Movement_PromoSalePriceList(
    IN inMovementId         Integer, -- ключ Документа
    IN inUserId             Integer  -- Пользователь
)
RETURNS TABLE (PartnerId   INTEGER, --Код партнера
               PriceListId INTEGER) --Код прайслиста
AS
$BODY$
BEGIN
    RETURN QUERY
        WITH Movement_PromoSalePartner AS(
            SELECT
                Movement.Id
            FROM 
                Movement
            WHERE
                Movement.ParentId = inMovementId
                AND
                Movement.DescId = zc_Movement_PromoSalePartner()
                AND
                Movement.StatusId <> zc_Enum_Status_Erased()
        )
        SELECT DISTINCT
            PriceList.PartnerId,
            COALESCE(PriceList.PriceListId,zc_PriceList_Basis()) as PriceListId
        FROM(
                SELECT
                    MovementLinkObject_Partner.ObjectId          AS PartnerId,
                    ObjectLink_Juridical_PriceList.ChildObjectId AS PriceListId
                FROM 
                    Movement_PromoSalePartner
                    INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement_PromoSalePartner.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                    INNER JOIN Object AS Object_Partner
                                      ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
                                     AND Object_Partner.DescId = zc_Object_Partner()
                    LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.ID
                                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                    LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                               ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                              AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                UNION ALL
                SELECT
                    MovementLinkObject_Partner.ObjectId          AS PartnerId,
                    ObjectLink_Juridical_PriceList.ChildObjectId AS PriceListId
                FROM 
                    Movement_PromoSalePartner
                    INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement_PromoSalePartner.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                    INNER JOIN Object AS Object_Juridical
                                      ON Object_Juridical.Id = MovementLinkObject_Partner.ObjectId
                                     AND Object_Juridical.DescId = zc_Object_Juridical()
                    LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                               ON ObjectLink_Juridical_PriceList.ObjectId = Object_Juridical.Id
                                              AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                UNION ALL
                SELECT
                    MovementLinkObject_Partner.ObjectId          AS PartnerId,
                    ObjectLink_Juridical_PriceList.ChildObjectId AS PriceListId
                FROM 
                    Movement_PromoSalePartner
                    INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                  ON MovementLinkObject_Partner.MovementId = Movement_PromoSalePartner.Id
                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                    INNER JOIN Object AS Object_Retail
                                      ON Object_Retail.Id = MovementLinkObject_Partner.ObjectId
                                     AND Object_Retail.DescId = zc_Object_Retail()
                    LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ChildObjectId = Object_Retail.Id
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                               ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
            ) AS PriceList;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.26         *
*/
-- SELECT * FROM lpGet_Movement_PromoSalePriceList (2641111, 5);