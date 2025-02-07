-- Function: gpSelect_MovementItem_PromoPartner()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoPartner(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (
        Id                  Integer --�������������
      , PartnerId           Integer --�� ������� <�������>
      , Code                Integer --��� �������  <�������>
      , Name                TVarChar --������������ ������� <�������>
      , JuridicalName       TVarChar --������������ ������� <��. ����>
      , RetailId            Integer  --
      , RetailName          TVarChar --������������ ������� <�������� ����>
      , AreaName            TVarChar --������������ ������� <������>
      , ContractId          Integer  --
      , ContractCode        TVarChar --� ���������
      , ContractName        TVarChar --�������� ���������
      , ContractTagName     TVarChar --������� ���������
      , IsErased            Boolean  --������� <������>
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoPartner());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
        SELECT
            MI_PromoPartner.Id                     AS Id              --�������������
          , MI_PromoPartner.ObjectId               AS PartnerId       --�� ������� <�������>
          , Object_Partner.ObjectCode::Integer     AS Code            --��� �������  <�������>
          , Object_Partner.ValueData               AS Name            --������������ ������� <�������>
          , COALESCE (Object_Juridical.ValueData, CASE WHEN Object_Partner.DescId = zc_Object_Juridical() THEN Object_Partner.ValueData END) :: TVarChar AS JuridicalName   --������������ ������� <��. ����>
          , Object_Retail.Id                       AS RetailId      --������������ ������� <�������� ����>
          , Object_Retail.ValueData                AS RetailName      --������������ ������� <�������� ����>
          , Object_Area.ValueData                  AS AreaName        --������������ ������� <������>
          , Object_Contract.ContractId             AS ContractId    --��� ���������
          , Object_Contract.ContractCode::TVarChar AS ContractCode    --��� ���������
          , Object_Contract.InvNumber              AS ContractName    --������������ ���������
          , Object_Contract.ContractTagName        AS ContractTagName --������� ���������
          , Object_Partner.IsErased                AS IsErased        -- ������� <������>
      
        FROM
            Movement AS Movement_PromoPartner
            INNER JOIN MovementItem AS MI_PromoPartner
                                    ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                   AND MI_PromoPartner.DescId = zc_MI_Master()
            INNER JOIN Object AS Object_Partner
                              ON Object_Partner.Id = MI_PromoPartner.ObjectId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT OUTER JOIN Object AS Object_Juridical
                                   ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.ID
                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT OUTER JOIN Object AS Object_Retail
                                   ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Area
                                       ON ObjectLink_Partner_Area.ObjectId = MI_PromoPartner.ObjectId
                                      AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
            LEFT OUTER JOIN Object AS Object_Area
                                   ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MI_PromoPartner.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS Object_Contract 
                                                     ON Object_Contract.ContractId = MILinkObject_Contract.ObjectId
        WHERE
            Movement_PromoPartner.ParentId = inMovementId
            AND 
            Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
            AND
            MI_PromoPartner.IsErased = FALSE;
            
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoPartner (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 30.11.15                                                          *
*/