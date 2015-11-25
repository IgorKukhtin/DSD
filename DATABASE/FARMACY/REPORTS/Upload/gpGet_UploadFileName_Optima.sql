-- Function: gpGet_UploadFileName_Optima ()

DROP FUNCTION IF EXISTS gpGet_UploadFileName_Optima (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_UploadFileName_Optima(
    IN inDate            TDateTime , --���� ��������
    IN inObjectId        Integer   , --���������
    IN inUnitId          Integer   , --�������������
   OUT outFileName       TVarChar  , -- ��� �����
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
    DECLARE vbUnitCode TVarChar;
BEGIN
    Select 
        Object_ImportExportLink.StringKey AS DeliveryCode
    INTO
        vbUnitCode
    FROM Object_ImportExportLink_View AS Object_ImportExportLink
        Inner Join Object ON Object_ImportExportLink.MainId = Object.ID
                         AND Object.DescId = zc_Object_Unit()
    WHERE
        Object_ImportExportLink.LinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance()
        AND
        Object_ImportExportLink.ValueId = inObjectId
        AND
        Object_ImportExportLink.MainId = inUnitId;
    outFileName := 'Report_'||COALESCE(vbUnitCode,'')||'_'||TO_CHAR(inDate,'YYYYMMDD');
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_UploadFileName_Optima (TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 25.11.15                                                                        *
*/

