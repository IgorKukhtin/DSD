--- Function: gpSelect_MovementItem_DistributionPromoChild()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_DistributionPromoChild (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_DistributionPromoChild(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , -- ���
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , JuridicalName TVarChar
             , RetailName    TVarChar
             , IsChecked Boolean
             , IsErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    IF inShowAll THEN
        -- ��������� �����
        RETURN QUERY
           WITH
           tmpUnit AS (SELECT Object_Unit.Id AS UnitId
                       FROM Object AS Object_Unit
                            INNER JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                  ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                                 AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                                                 AND ObjectLink_Unit_Parent.ChildObjectId > 0
                            INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                 AND ObjectLink_Juridical_Retail.ChildObjectId = 
                                                     (SELECT MovementLinkObject_Retail.ObjectId FROM MovementLinkObject AS MovementLinkObject_Retail
                                                      WHERE MovementLinkObject_Retail.MovementId = inMovementId
                                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail())                            
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                         AND Object_Unit.isErased = inIsErased OR inIsErased = TRUE
                       )
         , tmpMI AS (SELECT MI_DistributionPromo.Id             AS Id
                          , MI_DistributionPromo.ObjectId       AS ObjectId
                          , MI_DistributionPromo.Amount         AS Amount
                          , MI_DistributionPromo.IsErased       AS IsErased
                     FROM MovementItem AS MI_DistributionPromo
                    
                     WHERE MI_DistributionPromo.MovementId = inMovementId
                       AND MI_DistributionPromo.DescId = zc_MI_Child()
                       AND (MI_DistributionPromo.isErased = FALSE or inIsErased = TRUE)
                    )

           SELECT COALESCE (tmpMI.Id, 0)                AS Id
                , Object_Unit.Id                        AS UnitId
                , Object_Unit.ObjectCode                AS UnitCode
                , Object_Unit.ValueData                 AS UnitName
                , Object_Juridical.ValueData            AS JuridicalName
                , Object_Retail.ValueData               AS RetailName
                , CASE WHEN COALESCE (tmpMI.Amount, 0) = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , COALESCE (tmpMI.IsErased, FALSE)      AS IsErased
           FROM tmpUnit

               FULL JOIN tmpMI ON tmpMI.ObjectId = tmpUnit.UnitId
                         
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (tmpMI.ObjectId, tmpUnit.UnitId)

               LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                    ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
           ;
    ELSE
    -- ��������� ������
    RETURN QUERY
           SELECT MI_DistributionPromo.Id
                , Object_Unit.Id                   AS UnitId
                , Object_Unit.ObjectCode           AS UnitCode
                , Object_Unit.ValueData            AS UnitName
                , Object_Juridical.ValueData         AS JuridicalName
                , Object_Retail.ValueData            AS RetailName
                , CASE WHEN MI_DistributionPromo.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , MI_DistributionPromo.IsErased
           FROM MovementItem AS MI_DistributionPromo

               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MI_DistributionPromo.ObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                    ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           WHERE MI_DistributionPromo.MovementId = inMovementId
             AND MI_DistributionPromo.DescId = zc_MI_Child()
             AND (MI_DistributionPromo.isErased = FALSE or inIsErased = TRUE);
    END IF;
 
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.20                                                       *
*/

-- select * from gpSelect_MovementItem_DistributionPromoChild(inMovementId := 16406918  , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3'::TVarChar);
