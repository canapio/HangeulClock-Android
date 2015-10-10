package com.hangulclock.hansi;

enum ConvertType {tcType_hour, tcType_minute, tcType_second, tcType_month} ;

public class KoreanTranslator {

	private static final String HANGUL_UNIT_10 = "십";
	private static final String HANGUL_UNIT_100 = "백";
	private static final String HANGUL_UNIT_1000 = "천";

	/**
	 * 현재 시간(혹은 분, 초, 달)과 타입(단위)을 넣으면 한글로 변환해줍니다.
	 *  
	 * @param time time number in int
	 * @param type enum hour, min, sec, or month
	 * @return String
	 */
	public String convert(String time, ConvertType type) {
		if (time.equals("0")) return "영";

	    if (type == ConvertType.tcType_hour) {
			return this.houreStringWithUnit(time);
		}

		else if (type == ConvertType.tcType_minute || type == ConvertType.tcType_second || type == ConvertType.tcType_month) {
			String hangulStr = "";
			int unit = 0;
			int tmp = Integer.parseInt(time);
			while (tmp != 0) {
				int tmpMod = tmp % 10;
				if (tmpMod != 0) {
					if (unit == 1) hangulStr = HANGUL_UNIT_10 + hangulStr;
					else if (unit == 2) hangulStr = HANGUL_UNIT_100 + hangulStr;
					else if (unit == 3) hangulStr = HANGUL_UNIT_1000 + hangulStr;

					if (tmpMod != 1 || unit == 0) {
						hangulStr = this.minuteStringWithOneUnit(tmp % 10) + hangulStr;
					}

				}
				unit++;
				tmp /= 10;
			}
			if (type == ConvertType.tcType_month) {
				if (hangulStr.equals("육")) hangulStr = "유";
				else if (hangulStr.equals("십")) hangulStr = "시";
			}

			return hangulStr;

		} else {
			return null;
		}
	}
	

	/**
	 * 아래와 같이 동작하는 메소드
	 * 한글 -> ㅎㅏㄴㄱㅡㄹ
	 * 
	 * @param str input string
	 * @return String
	 */
	public String linearHangul (String str) {
		String returnStr = "";
		
		// typo 스트링의 글자수 만큼 list에 담아둡니다.
		for (int i = 0; i < str.length(); i++) {
			char comVal = (char) (str.charAt(i) - 0xAC00);

			// 한글이 아닐경우
			//System.out.println(comVal+" ");
			if (comVal >= 0 && comVal <= 11172){
				// 한글일경우 
				
				// 초성만 입력 했을 시엔 초성은 무시해서 List에 추가합니다.
				char uniVal = (char)comVal;

				// 유니코드 표에 맞추어 초성 중성 종성을 분리합니다..
				char cho = (char) ((((uniVal - (uniVal % 28)) / 28) / 21) + 0x1100);
				char jung = (char) ((((uniVal - (uniVal % 28)) / 28) % 21) + 0x1161);
				char jong = (char) ((uniVal % 28) + 0x11a7);

				if(cho != 4519){
					//System.out.println(cho+" ");
					returnStr += cho + " ";
				}
				if(jung != 4519){
					//System.out.println((int)jung+" ");
					if (jung == 4463) {
						returnStr += "ㅜㅓ" + " ";
					} else if (jung == 4458) {
						returnStr += "ㅗㅏ" + " ";
					} else {
						returnStr += jung + " ";
					}
				}
				if(jong != 4519){
					//System.out.println(jong+" ");
					returnStr += jong + " ";
				}
		
			} else comVal = (char) (comVal + 0xAC00);
		}
		// returnStr = returnStr.replaceAll("\\s+","");
		return returnStr;
	}
	/**
	 * @param dow (1:일요일 ~ 7:토요일)
	 * @return String
	 */
	public String dayOfWeekHanhulWithIndex (String dow) {
		String day = null;
		switch (dow) {
			case "Sun": day = "일"; break;
			case "Mon": day = "월"; break;
			case "Tue": day = "화"; break;
			case "Wed": day = "수"; break;
			case "Thu": day = "목"; break;
			case "Fri": day = "금"; break;
			case "Sat": day = "토"; break;
		}

		return day;
	}
	
	public String timeAMPM(String ampm) {
		if (ampm.equals("AM")) return "전";
		else return "후";
	}

	private String minuteStringWithOneUnit(int time) {
		String min = null;
		switch (time) {
			case 0: min = "영"; break;
			case 1: min = "일"; break;
			case 2: min = "이"; break;
			case 3: min = "삼"; break;
			case 4: min = "사"; break;
			case 5: min = "오"; break;
			case 6: min = "육"; break;
			case 7: min = "칠"; break;
			case 8: min = "팔"; break;
			case 9: min = "구"; break;
		}
		return min;
	}

	private String houreStringWithUnit(String time) {
		String hour = null;
		switch (time) {
			case "0": hour = "영"; break;
			case "1": hour = "한"; break;
			case "2": hour = "두"; break;
			case "3": hour = "세"; break;
			case "4": hour = "네"; break;
			case "5": hour = "다섯"; break;
			case "6": hour = "여섯"; break;
			case "7": hour = "일곱"; break;
			case "8": hour = "여덟"; break;
			case "9": hour = "아홉"; break;
			case "10": hour = "열"; break;
			case "11": hour = "열한"; break;
			case "12": hour = "열두"; break;
			case "13": hour = "열세"; break;
			case "14": hour = "열네"; break;
			case "15": hour = "열다섯"; break;
			case "16": hour = "열여섯"; break;
			case "17": hour = "열일곱"; break;
			case "18": hour = "열여덟"; break;
			case "19": hour = "열아홉"; break;
			case "20": hour = "스무"; break;
			case "21": hour = "스물한"; break;
			case "22": hour = "스물두"; break;
			case "23": hour = "스물세"; break;
		}

		return hour;
	}
}

