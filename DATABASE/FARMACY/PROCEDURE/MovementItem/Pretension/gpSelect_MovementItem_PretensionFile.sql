-- Function: gpSelect_MovementItem_PretensionFile()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PretensionFile (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PretensionFile(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Number Integer, FileName TVarChar, isAct Boolean
             , FileNameFTP TVarChar, FolderTMP TVarChar, FileNameDownload TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbMovementIncomeId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    
      RETURN QUERY
          WITH 

           PretensionFile AS (SELECT MI_PretensionFile.Id
                                   , ROW_NUMBER() OVER (ORDER BY MI_PretensionFile.Id)::Integer                AS Number
                                   , MIString_FileName.ValueData                                               AS FileName
                                   , COALESCE(MIBoolean_Checked.ValueData, FALSE)                              AS isAct
                                   , MI_PretensionFile.Id::TVarChar                                            AS FileNameFTP
                                   , 'tmpPretensionFile\'::TVarChar                                            AS FolderTMP
                                   , ''::TVarChar                                                              AS FileNameDownload
                                   , MI_PretensionFile.isErased
                              FROM Movement AS Movement_Pretension
                                   INNER JOIN MovementItem AS MI_PretensionFile
                                                           ON MI_PretensionFile.MovementId = Movement_Pretension.Id
                                                          AND MI_PretensionFile.DescId     = zc_MI_Child()

                                   LEFT JOIN MovementItemString AS MIString_FileName
                                                                ON MIString_FileName.MovementItemId = MI_PretensionFile.Id
                                                               AND MIString_FileName.DescId = zc_MIString_FileName()

                                   LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                                 ON MIBoolean_Checked.MovementItemId = MI_PretensionFile.Id
                                                                AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()

                              WHERE Movement_Pretension.Id = inMovementId
                             )

          SELECT
              MovementItem.Id
            , MovementItem.Number  
            , MovementItem.FileName
            , MovementItem.isAct
            , MovementItem.FileNameFTP
            , MovementItem.FolderTMP
            , MovementItem.FileNameDownload
            , MovementItem.isErased
      FROM PretensionFile AS MovementItem
      WHERE (MovementItem.isErased  = FALSE OR inIsErased = TRUE)
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.12.21                                                       *
 
*/

-- ����
select * from gpSelect_MovementItem_PretensionFile(inMovementId := 26008006  ,inIsErased := 'False' ,  inSession := '3');