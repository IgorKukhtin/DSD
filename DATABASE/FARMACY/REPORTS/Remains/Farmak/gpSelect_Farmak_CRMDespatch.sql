 -- Function: gpSelect_Farmak_CRMDespatch()

DROP FUNCTION IF EXISTS gpSelect_Farmak_CRMDespatch (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Farmak_CRMDespatch(
    IN inMakerId          Integer,    -- Производитель
    IN inDateStart        TDateTime,  -- Документы с даты
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, DocumentDate TDateTime, DocumentNumber TVarChar, WarehouseId Integer, PharmacyId Integer, PharmacistId Integer
             , CompanyId Integer, AddressId Integer, DstCodeId Integer
             , WareId Integer, Price TFloat, Quantity TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY
        WITH
          tmpGoodsPromo AS (SELECT DISTINCT GoodsPromo.GoodsID
                                          , GoodsPromo.WareId
                                          , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 7) AS NDS
                            FROM gpSelect_Farmak_CRMWare (inMakerId, inSession) AS GoodsPromo
                                 LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = GoodsPromo.GoodsID
                                 LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                 LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                       ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                                      AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
         , tmpUnit AS (SELECT DISTINCT UnitPromo.ID AS UnitId, UnitPromo.PharmacyId
                            FROM gpSelect_Farmak_CRMPharmacy ('3') AS UnitPromo)
         , tmpContainer AS (SELECT Container.Id                   AS ContainerId
                                 , Container.ObjectId             AS GoodsID
                                 , Container.WhereObjectId        AS UnitId
                                 , MIContainer.MovementId         AS MovementId
                                 , MIContainer.MovementItemId     AS MovementItemId
                                 , MIContainer.OperDate           AS OperDate
                                 , -1.0 * MIContainer.Amount      AS Amount
                            FROM Container
                                INNER JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsID = Container.ObjectId
                                INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId

                                INNER JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.ContainerId = Container.Id
                                                                AND MIContainer.DescId = zc_Container_Count()
                                                                AND MIContainer.OperDate >= DATE_TRUNC ('DAY', inDateStart) - INTERVAL '7 DAY'
                                                                AND MIContainer.OperDate <= CURRENT_DATE
                                                                AND MIContainer.MovementDescId IN (zc_Movement_Check(), zc_Movement_ReturnIn(), zc_Movement_Sale())
                                                                AND MIContainer.Amount <> 0

                            WHERE Container.DescId = zc_Container_Count())
         , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                        , MovementProtocol.OperDate
                                        , CASE WHEN SUBSTRING(MovementProtocol.ProtocolData, POSITION('Статус' IN MovementProtocol.ProtocolData) + 22, 1) = 'П'
                                               THEN TRUE ELSE FALSE END AS Status
                                        , ROW_NUMBER() OVER (Partition BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate) AS ord
                                    FROM (SELECT DISTINCT tmpContainer.MovementId AS ID FROM tmpContainer) Movement

                                        INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID)
         , tmpMovementStatus AS (SELECT tmpMovementProtocol.MovementId
                                      , Min(tmpMovementProtocol.OperDate) AS OperDate
                                 FROM tmpMovementProtocol
                                      INNER JOIN tmpMovementProtocol AS MovementProtocolPrew
                                                                     ON MovementProtocolPrew.MovementId = tmpMovementProtocol.MovementId
                                                                    AND MovementProtocolPrew.ord = tmpMovementProtocol.ord - 1
                                                                    AND MovementProtocolPrew.Status = False
                                 WHERE tmpMovementProtocol.Status = True
                                 GROUP BY tmpMovementProtocol.MovementId )

        -- Результат
        SELECT Movement.Id                                          AS MovementId
             , tmpData.OperDate::TDateTime                          AS DocumentDate
             , (tmpData.MovementItemId::TVarChar||'-'||Movement.InvNumber)::TVarChar AS DocumentNumber
             , NULL::Integer                                        AS WarehouseId
             , tmpUnit.PharmacyId                                   AS PharmacyId
             , Object_User.ObjectCode                               AS PharmacistId
             , NULL::Integer                                        AS CompanyId
             , NULL::Integer                                        AS AddressId
             , NULL::Integer                                        AS DstCodeId
             , tmpGoodsPromo.WareId                                 AS WareId
             , COALESCE (COALESCE(MIF_Price.ValueData, MIF_PriceSale.ValueData) / (100.0 + tmpGoodsPromo.NDS) * 100.0, 0)::TFloat  AS Price
             , tmpData.Amount:: TFloat                              AS Quantity
        FROM tmpContainer AS tmpData

             INNER JOIN tmpMovementStatus ON tmpMovementStatus.MovementId = tmpData.MovementId
                                         AND tmpMovementStatus.OperDate >= DATE_TRUNC ('DAY',inDateStart)
                                         AND tmpMovementStatus.OperDate < CURRENT_DATE

             LEFT JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsID = tmpData.GoodsID
             LEFT JOIN tmpUnit ON tmpUnit.UnitId = tmpData.UnitId

             LEFT JOIN Movement ON Movement.Id = tmpData.MovementId

             LEFT JOIN MovementItemFloat AS MIF_Price
                                         ON MIF_Price.MovementItemId = tmpData.MovementItemId
                                        AND MIF_Price.DescId = zc_MIFloat_Price()
                                        AND MIF_Price.ValueData > 0
             LEFT JOIN MovementItemFloat AS MIF_PriceSale
                                         ON MIF_PriceSale.MovementItemId = tmpData.MovementItemId
                                        AND MIF_PriceSale.DescId = zc_MIFloat_PriceSale()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                          ON MovementLinkObject_Insert.MovementId = tmpData.MovementId
                                         AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                          ON MovementLinkObject_UserConfirmedKind.MovementId = tmpData.MovementId
                                         AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()
             LEFT JOIN Object as Object_User ON Object_User.ID = COALESCE(MovementLinkObject_Insert.ObjectId, MovementLinkObject_UserConfirmedKind.ObjectId)

        ORDER BY tmpData.MovementId
         ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.03.21                                                       *
*/

-- тест
--
SELECT * FROM gpSelect_Farmak_CRMDespatch(13648288 , '01.03.2021', '3')