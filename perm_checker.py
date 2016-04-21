#!/usr/bin/env python

import json
import urllib2
import datetime
import sys

days_past = 1
yesterday = (datetime.date.today() - datetime.timedelta(days_past)).strftime("%m/%d/%Y")
today = datetime.date.today().strftime("%m/%d/%Y")

#### url_query_general = 'https://icert.doleta.gov/index.cfm?event=ehLCJRExternal.dspQuickCertSearchGridData&&startSearch=1&case_number=&employer_business_name=&visa_class_id=6&state_id=all&location_range=10&location_zipcode=&job_title=&naic_code=&create_date=undefined&post_end_date=undefined&h1b_data_series=ALL&start_date_from=%s&start_date_to=%s&nd=1398964397596&page=1&rows=9999&sidx=create_date&sord=desc&nd=1398964397597&_search=false' % (yesterday,today)
#####url_query_general = 'https://icert.doleta.gov/index.cfm?event=ehLCJRExternal.dspQuickCertSearchGridData&&startSearch=1&case_number=&employer_business_name=&visa_class_id=6&state_id=all&location_range=10&location_zipcode=&job_title=&naic_code=&start_date_from=%s&start_date_to=%s&page=1&rows=9999&sidx=create_date&sord=desc' % (yesterday,today)
######url_query_general = 'https://icert.doleta.gov/index.cfm?event=ehLCJRExternal.dspQuickCertSearchGridData&startSearch=1&visa_class_id=6&start_date_from=%s&start_date_to=%s&page=1&rows=9999&sidx=create_date&sord=desc' % (yesterday,today)

def loop_through_all_pages(page_number=1, row_count=9999, company="", case_number="", loop=False):
    while True:
        url_query_general = 'https://icert.doleta.gov/index.cfm?event=ehLCJRExternal.dspQuickCertSearchGridData&startSearch=1&employer_business_name=%s&case_number=%s&visa_class_id=6&start_date_from=%s&start_date_to=%s&page=%i&rows=%i&sidx=case_number&sord=asc' % (company, case_number, yesterday, today, page_number, row_count)

        if case_number != "":
            url_query_general = 'https://icert.doleta.gov/index.cfm?event=ehLCJRExternal.dspQuickCertSearchGridData&startSearch=1&case_number=%s&visa_class_id=6&page=%i&rows=%i&sidx=case_number&sord=asc' % (case_number, page_number, row_count)

        raw_results = urllib2.urlopen(url_query_general).read()
        ##print raw_results
        results = json.loads(raw_results)
        rows = results['ROWS']
        result_row_count = len(rows)


        if result_row_count == 0:
            print 'found nothing'
            print '\n\n'
            break


        if company != "":
            print company.replace('%20', ' ').upper()
        if case_number != "":
            print case_number.upper()
        #print json.dumps(results, sort_keys = False, indent = 4)


        print ('total number of results fetched %i' % result_row_count)
        print '\n\n'
        print 'QUERY: %s' % url_query_general
        if company == "" and case_number == "" and result_row_count > 0:
            case_approval_spread = {}
            for row in rows:
                case_no = row[1]
                company = row[5].upper()
                state = "yyyyyySTATE%s" % row[9].upper()
                case_no_list = case_no.split("-")
                year = int(case_no_list[1][:2]) + 2000
                day_of_year = int(case_no_list[1][2:])
                date = datetime.date(year, 1, 1) + datetime.timedelta(day_of_year - 1)
                date_s = date.strftime('zzzzzz%Y-%m-%d')
                date_month = date.strftime('zzzzzz99999%Y-%m')
                date_year = date.strftime('zzzzzz999999%Y')
                if date_s not in case_approval_spread:
                    case_approval_spread[date_s] = 1
                else:
                    case_approval_spread[date_s] += 1
                if date_month not in case_approval_spread:
                    case_approval_spread[date_month] = 1
                else:
                    case_approval_spread[date_month] += 1
                if date_year not in case_approval_spread:
                    case_approval_spread[date_year] = 1
                else:
                    case_approval_spread[date_year] += 1
                if company not in case_approval_spread:
                    case_approval_spread[company] = 1
                else:
                    case_approval_spread[company] += 1
                if state not in case_approval_spread:
                    case_approval_spread[state] = 1
                else:
                    case_approval_spread[state] += 1
            state_nl = False
            date_nl = False
            month_nl = False
            year_nl = False
            print "\n\n"
            for key in sorted(case_approval_spread.keys()):
                if 'yyyyyySTATE' in key and not state_nl:
                    state_nl = True
                    print "\n\n"
                if 'zzzzzz' in key and not date_nl:
                    date_nl = True
                    print "\n\n"
                if '99999' in key and not month_nl:
                    month_nl = True
                    print "\n\n"
                if '999999' in key and not year_nl:
                    year_nl = True
                    print "\n\n"
                print "%s: %i" % (key.replace('999999','').replace('99999','').replace('zzzzzz','').replace('yyyyyySTATE',''), case_approval_spread[key])
            print "\n"
            print ('TOTAL %i' % result_row_count)
            print 'LATEST %s - %s' % (yesterday, today)
            print json.dumps(rows[result_row_count - 1], sort_keys = False, indent = 4)

            print "\n\n"

        if not loop:
          break
        page_number += 1


print 'looking for cases since %s and %s' % (yesterday, today)
page_number = 1
row_count = 9999
loop_through_all_pages(page_number, row_count)
