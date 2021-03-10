 -- Function: gpSelect_Farmak_CRMClient()

DROP FUNCTION IF EXISTS gpSelect_Farmak_CRMClient (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Farmak_CRMClient(
    IN inMakerId          Integer,    -- �������������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (CompanyId TVarChar, CompanyName TVarChar, CompanyAddress TVarChar
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
          tmpGoodsPromo AS (SELECT DISTINCT GoodsPromo.GoodsID, GoodsPromo.WareId
                            FROM gpSelect_Farmak_CRMWare (inMakerId, inSession) AS GoodsPromo)
         , tmpUnit AS (SELECT DISTINCT UnitPromo.ID AS UnitId, UnitPromo.PharmacyId
                            FROM gpSelect_Farmak_CRMPharmacy ('3') AS UnitPromo)
         , tmpContainer AS (SELECT Container.Id                   AS ContainerId
                            FROM Container
                                INNER JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsID = Container.ObjectId
                                INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId

                            WHERE Container.DescId = zc_Container_Count()
                              AND Container.Amount > 0)
         , tmpContainerIncome AS (SELECT Container.ContainerId
                                       , MovementLinkObject_From.ObjectId   AS FromId
                                  FROM tmpContainer AS Container

                                       LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                     ON ContainerLinkObject_MovementItem.Containerid = Container.ContainerId
                                                                    AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                       LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                       -- ������� �������
                                       LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                       -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                       LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                   ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                  AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                       -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                       LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                                       LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                    ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)   
                                                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  UNION ALL
                                  SELECT 0, 393054 
                                  )
         , tmpJuridical AS (SELECT * FROM gpSelect_Object_Juridical(inSession := inSession))

        -- ���������
        SELECT tmpJuridical.okpo                              AS CompanyId
             , tmpJuridical.fullname                          AS CompanyName
             , tmpJuridical.juridicaladdress                  AS CompanyAddress
        FROM (SELECT DISTINCT FromId FROM tmpContainerIncome) AS tmpData

             LEFT JOIN tmpJuridical ON tmpJuridical.ID = tmpData.FromId

        WHERE COALESCE(tmpJuridical.okpo, '') <> ''
          AND COALESCE(tmpJuridical.juridicaladdress, '') <> ''
        ORDER BY tmpData.FromId;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.03.21                                                       *
*/

-- ����
-- 
SELECT * FROM gpSelect_Farmak_CRMClient(13648288 , '3')