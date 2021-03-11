 -- Function: gpSelect_Farmak_CRMWhReceipt()

DROP FUNCTION IF EXISTS gpSelect_Farmak_CRMWhReceipt (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Farmak_CRMWhReceipt(
    IN inMakerId          Integer,    -- �������������
    IN inDateStart        TDateTime,  -- ��������� � ����
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer, DocumentDate TDateTime, DocumentNumber TVarChar, WarehouseId Integer, PharmacyId Integer
             , CompanyId Integer, SrcCodeId Integer
             , WareId Integer, Price TFloat, Quantity TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- ����������� �� �������� ��������� �����������
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- ���������
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
                                 , MIContainer.Amount             AS Amount
                            FROM Container
                                INNER JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsID = Container.ObjectId
                                INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId

                                INNER JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.ContainerId = Container.Id
                                                                AND MIContainer.DescId = zc_Container_Count()
                                                                AND MIContainer.OperDate >= DATE_TRUNC ('DAY',inDateStart) - INTERVAL '7 DAY'
                                                                AND MIContainer.OperDate <= CURRENT_DATE
                                                                AND MIContainer.MovementDescId  = zc_Movement_Income()
                                                                AND MIContainer.Amount <> 0

                            WHERE Container.DescId = zc_Container_Count())
         , tmpObjectHistory AS (SELECT *
                                FROM ObjectHistory
                                WHERE ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
                                  AND ObjectHistory.enddate::timestamp with time zone = zc_dateend()::timestamp with time zone
                                )
         , tmpJuridicalDetails AS (SELECT ObjectHistory_JuridicalDetails.ObjectId                                        AS JuridicalId
                                        , ObjectHistoryString_JuridicalDetails_OKPO.ValueData                            AS OKPO

                                   FROM tmpObjectHistory AS ObjectHistory_JuridicalDetails
                                        LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                               ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                              AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
                                   )
         , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                        , MovementProtocol.OperDate
                                        , CASE WHEN SUBSTRING(MovementProtocol.ProtocolData, POSITION('������' IN MovementProtocol.ProtocolData) + 22, 1) = '�'
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

        -- ���������
        SELECT Movement.Id                                          AS MovementId
             , tmpData.OperDate::TDateTime                          AS DocumentDate
             , Movement.InvNumber                                   AS DocumentNumber
             , NULL::Integer                                        AS WarehouseId
             , tmpUnit.PharmacyId                                   AS PharmacyId
             , tmpJuridicalDetails.OKPO::Integer                    AS CompanyId
             , NULL::Integer                                        AS SrcCodeId
             , tmpGoodsPromo.WareId                                 AS WareId
             , COALESCE (MIF_PriceWithOutVAT.ValueData, 0)::TFloat  AS Price
             , tmpData.Amount:: TFloat                              AS Quantity
        FROM tmpContainer AS tmpData

             INNER JOIN tmpMovementStatus ON tmpMovementStatus.MovementId = tmpData.MovementId
                                         AND tmpMovementStatus.OperDate >= DATE_TRUNC ('DAY',inDateStart)
                                         AND tmpMovementStatus.OperDate < CURRENT_DATE

             LEFT JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsID = tmpData.GoodsID
             LEFT JOIN tmpUnit ON tmpUnit.UnitId = tmpData.UnitId

             LEFT JOIN Movement ON Movement.Id = tmpData.MovementId

             LEFT JOIN MovementItemFloat AS MIF_PriceWithOutVAT
                                         ON MIF_PriceWithOutVAT.MovementItemId = tmpData.MovementItemId
                                        AND MIF_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = tmpData.MovementId
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalId = MovementLinkObject_From.ObjectId



        ORDER BY tmpData.MovementId
         ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.03.21                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Farmak_CRMWhReceipt(13648288 , '01.03.2021', '3')