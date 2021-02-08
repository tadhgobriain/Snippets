/*

RegCode: QP
Description: Qualifier and Attending - Taking tuition and qualifier exams
Access Required: Yes
Cut-off Date: No

RegCode: RG
Description: Registered - all fees paid
Access Required: Yes
Cut-off Date: No

RegCode: RP
Description: Repeat Tuition 
Access Required: Yes
Cut-off Date: No

RegCode: WU
Description: Write up - Post Grad students in the process of writing up Thesis
Access Required: Yes
Cut-off Date: May be cut-off by finance if payment dates are not met

RegCode: TR
Description: Temporary Registered  - Paid some fees but some fee outstanding
Access Required: Yes
Cut-off Date: Finance may put these students on hold if payment dates are not met

RegCode: EL
Description: Eligible to register
Access Required: Yes (first time attending full time students only)
Cut-off Date: Active until end 30th September (proposed)

RegCode: DE
Description: Deferred - Student has deferred tuition
Access Required: No
Cut-off Date: Null

RegCode: NS
Description: No Show - Student has not presented for registration or responded to requests inviting to register
Access Required: No
Cut-off Date: Null

RegCode: QX
Description: Qualifier Examinations only - No Tuition
Access Required: Yes (to be reviewed)
Cut-off Date: Null

RegCode: RX
Description: Repeat examinations only - No Tuition
Access Required: Maybe
Cut-off Date: Yes, discretionary

RegCode: WD
Description: Withdrawn - Student no longer attending and officially withdrawn
Access Required: No
Cut-off Date: Null

 */

SELECT ID AS SamAccountName, TO_CHAR(BIRTHDATE, 'DDMonYY') AS PASSWORD, FIRSTNAME, LASTNAME, YEARATT, PROGRAMME, REGCODE, ACCOUNT_ACTION, SUBSTR(TERM,1,4) AS TERM
    FROM ITT_STUDENT 
                
    WHERE (PROGRAMME LIKE 'TA_K%' OR PROGRAMME LIKE 'TA_S%' OR PROGRAMME LIKE 'FS_S%')
        /* 
        'TA_SCPHA_B' students are registered FT in a partner institution, attending as 'Y4' in our institution only.
        They are registered as P1|P2|P3 for administration purposes only, but do not get an AD account
        for reasons such as GDPR adherence, licence consumption, security(least privilege).
        */
        AND NOT (PROGRAMME = 'TA_SCPHA_B' AND YEARATT LIKE 'P%')  
/* What regcodes are valid before/after regcode cut-off date?  */
	AND ((REGCODE IN ('QX','QP','RG','RP','TR')
	      	OR ( /* YEARATT LIKE 'Y%' AND */ REGCODE = 'EL' AND TRUNC(SYSDATE) >= TO_DATE('01SEP2020') AND TRUNC(SYSDATE) < TO_DATE('09FEB2021')))
	      /* Students resitting exams are valid until a specific discretionary date  */  
	      OR (REGCODE = 'RX' AND TRUNC(SYSDATE) < TO_DATE('07SEP2021'))
            /* Research students writing up are always valid */ 
            OR REGCODE = 'W%')
			    
/* What is the academic year cut-off date? */  
        AND (((TERM = '202000' OR TERM = '201900') AND TRUNC(SYSDATE) >= TO_DATE('01SEP2020') AND TRUNC(SYSDATE) <= TO_DATE('28FEB2021'))
    		OR (TERM = '202000' AND TRUNC(SYSDATE) > TO_DATE('28FEB2021')))  
                      
            AND REGEXP_LIKE (ID, '^x[0-9]{8}$','i')
                
            AND BIRTHDATE IS NOT NULL
