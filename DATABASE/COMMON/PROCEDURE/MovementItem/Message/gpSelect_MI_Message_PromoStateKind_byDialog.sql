-- Function: gpSelect_MI_Message_PromoStateKind_byDialog (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MI_Message_PromoStateKind_byDialog (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Message_PromoStateKind_byDialog (
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Ord Integer
             , Comment TVarChar
             , PromoStateKindId Integer, PromoStateKindName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Promo());
     vbUserId := inSession;

     -- ���������
     RETURN QUERY 

     SELECT MovementItem.Id                        AS Id
          , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord
          , MIString_Comment.ValueData :: TVarChar AS Comment
          , Object_PromoStateKind.Id               AS PromoStateKindId
          , Object_PromoStateKind.ValueData        AS PromoStateKindName
          , MovementItem.isErased                  AS isErased
     FROM MovementItem
          LEFT JOIN Object AS Object_PromoStateKind ON Object_PromoStateKind.Id = MovementItem.ObjectId

          INNER JOIN MovementItemString AS MIString_Comment
                                        ON MIString_Comment.MovementItemId = MovementItem.Id
                                       AND MIString_Comment.DescId = zc_MIString_Comment()
                                       AND COALESCE (MIString_Comment.ValueData,'') <> ''
 
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Message()
       AND (MovementItem.isErased = inIsErased OR inIsErased = TRUE)
       AND Object_PromoStateKind.DescId = zc_Object_PromoStateKind()
     ORDER BY 2 DESC
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.10.20         * 
*/

-- ����