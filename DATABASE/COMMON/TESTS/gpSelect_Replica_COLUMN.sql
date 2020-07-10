-- Function: gpSelect_Replica_Column()

DROP FUNCTION IF EXISTS gpSelect_Replica_Column (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Replica_Column(
    IN inId_start     Integer,
    IN inId_end       Integer
)
RETURNS TABLE (TABLE_NAME Text, COLUMN_NAME Text, COLUMN_NAME_full Text
) AS
$BODY$
BEGIN

   RETURN QUERY 
    SELECT tmp.TABLE_NAME :: Text
         , STRING_AGG (tmp.COLUMN_NAME , ',''||''' ORDER BY COLUMN_POSITION)    :: Text                   AS COLUMN_NAME
         , STRING_AGG ( 'CASE WHEN CAST (' || tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME || ' AS TVarChar) IS NULL'
                        || ' THEN ' || zfStr_CHR_39 ('NULL')
                        || ' ELSE CAST (' || CASE WHEN tmp.COLUMN_TYPENAME ILIKE 'TVarChar'
                                                    OR tmp.COLUMN_TYPENAME ILIKE 'TDateTime'
                                                    OR tmp.COLUMN_TYPENAME ILIKE 'Text'
                                                    OR tmp.COLUMN_TYPENAME ILIKE 'Text'
                                               THEN zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || '||' || tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME || '||' || zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l')
                                             ELSE tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME
                                             END || '  AS TVarChar)'
                        || ' END' , '||'',''||' ORDER BY COLUMN_POSITION)  :: Text AS  COLUMN_NAME_full

    FROM (SELECT * FROM gpSelect_Replica_Table (inId_start, inId_end)) AS tmp
    GROUP BY tmp.TABLE_NAME
    ORDER BY 1;
     
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.07.20          *
*/

-- ����
--
-- SELECT * FROM gpSelect_Replica_Column(507132, 657179)
