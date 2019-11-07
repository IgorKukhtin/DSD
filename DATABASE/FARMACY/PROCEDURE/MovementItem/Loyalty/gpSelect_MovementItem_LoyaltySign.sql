--- Function: gpSelect_MovementItem_LoyaltySign()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_LoyaltySign (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_LoyaltySign(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , -- ���
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id         Integer
             , GUID       TVarChar
             , OperDate   TDateTime
             , Amount     TFloat
             , UnitName   TVarChar
             , Comment    TVarChar

             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased   Boolean
             
             , Invnumber_Check     Integer
             , OperDate_Check      TDateTime
             , UnitName_Check      TVarChar

             , Invnumber_CheckSale Integer
             , OperDate_CheckSale  TDateTime
             , UnitName_CheckSale  TVarChar

              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

        RETURN QUERY
        WITH
        tmpMIF AS (SELECT * FROM MovementFloat AS MovementFloat_MovementItemId
                   WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                  )
      , tmpMI AS (SELECT MI_Sign.Id
                       , MI_Sign.Amount
                       , MI_Sign.ObjectId
                       , MI_Sign.IsErased
                       , MI_Sign.ParentId                                      AS MovementId
                       , MovementFloat_MovementItemId.MovementId               AS MovementSaleId
       
                  FROM MovementItem AS MI_Sign
                       LEFT JOIN tmpMIF AS MovementFloat_MovementItemId
                                        ON MovementFloat_MovementItemId.ValueData = MI_Sign.Id
                  WHERE MI_Sign.MovementId = inMovementId
                    AND MI_Sign.DescId = zc_MI_Sign()
                    AND (MI_Sign.isErased = FALSE or inIsErased = TRUE)
                  )
      , tmpCheck AS (SELECT tmpMI.Id                   AS ID
                          , CASE WHEN Movement.ID = tmpMI.MovementId THEN True ELSE FALSE END AS isIssue
                          , Movement.OperDate          AS OperDate
                          , Movement.Invnumber         AS Invnumber
                          , Object_Unit.ValueData      AS UnitName
                          , Object_Juridical.ValueData AS JuridicalName
                          , Object_Retail.ValueData    AS RetailName
                     FROM tmpMI 
                     
                          LEFT JOIN Movement ON Movement.ID IN (tmpMI.MovementId, tmpMI.MovementSaleId) 
                          
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                          
                          LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                               ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                     )

           SELECT MI_Sign.Id
                , MIString_GUID.ValueData       ::TVarChar AS GUID

                , MIDate_OperDate.ValueData                AS OperDate
                , MI_Sign.Amount
                , Object_Unit.ValueData                    AS UnitName
                , MIString_Comment.ValueData               AS Comment
                
                , Object_Insert.ValueData                  AS InsertName
                , Object_Update.ValueData                  AS UpdateName
                , MIDate_Insert.ValueData                  AS InsertDate
                , MIDate_Update.ValueData                  AS UpdateDate

                , MI_Sign.IsErased
                
                -- ������ �� ���� ��������
                , tmpCheck.Invnumber            ::Integer   AS Invnumber_Check
                , tmpCheck.OperDate             ::TDateTime AS OperDate_Check 
                , tmpCheck.UnitName             ::TVarChar  AS UnitName_Check

                -- ������ �� ���� ���������
                , tmpCheckSale.Invnumber         ::Integer   AS Invnumber_CheckSale
                , tmpCheckSale.OperDate         ::TDateTime AS OperDate_CheckSale 
                , tmpCheckSale.UnitName         ::TVarChar  AS UnitName_CheckSale
                
           FROM tmpMI AS MI_Sign

               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MI_Sign.ObjectId

               LEFT JOIN tmpCheck ON tmpCheck.Id = MI_Sign.Id
                                 AND tmpCheck.isIssue = True
                 
               LEFT JOIN tmpCheck AS tmpCheckSale
                                  ON tmpCheckSale.Id = MI_Sign.Id
                                 AND tmpCheckSale.isIssue = False

               LEFT JOIN MovementItemString AS MIString_GUID
                                            ON MIString_GUID.MovementItemId = MI_Sign.Id
                                           AND MIString_GUID.DescId = zc_MIString_GUID()
               LEFT JOIN MovementItemDate AS MIDate_OperDate
                                          ON MIDate_OperDate.MovementItemId = MI_Sign.Id
                                         AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                                                      
               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MI_Sign.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()

               LEFT JOIN MovementItemDate AS MIDate_Insert
                                          ON MIDate_Insert.MovementItemId = MI_Sign.Id
                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
               LEFT JOIN MovementItemDate AS MIDate_Update
                                          ON MIDate_Update.MovementItemId = MI_Sign.Id
                                         AND MIDate_Update.DescId = zc_MIDate_Update()
  
               LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                ON MILO_Insert.MovementItemId = MI_Sign.Id
                                               AND MILO_Insert.DescId = zc_MILinkObject_Insert()
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
               LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                ON MILO_Update.MovementItemId = MI_Sign.Id
                                               AND MILO_Update.DescId = zc_MILinkObject_Update()
               LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
           ORDER BY MIDate_OperDate.ValueData;
  
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.11.19                                                       *
*/


-- select * from gpSelect_MovementItem_LoyaltySign(inMovementId := 16406918 , inIsErased := 'False' ,  inSession := '3');
