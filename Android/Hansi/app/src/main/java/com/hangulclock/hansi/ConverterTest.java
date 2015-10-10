package com.hangulclock.hansi;

public class ConverterTest {
	public static void main(String[] args) {
		KoreanTranslator converter = new KoreanTranslator();
		
		System.out.println("1. "+ converter.convert("10", ConvertType.tcType_hour)+"시");
		System.out.println("2. "+ converter.convert("11", ConvertType.tcType_hour)+"시");
		System.out.println(" ");
		
		System.out.println("3. "+ converter.convert("15", ConvertType.tcType_minute)+"분");
		System.out.println("4. "+ converter.convert("56", ConvertType.tcType_minute)+"분");
		System.out.println(" ");
		
		System.out.println("5. "+ converter.convert("22", ConvertType.tcType_second)+"초");
		System.out.println("6. "+ converter.convert("43", ConvertType.tcType_second)+"초");
		System.out.println(" ");
		
		System.out.println("7. "+ converter.dayOfWeekHanhulWithIndex("Sun"));
		System.out.println(" ");
		
		System.out.println("8. "+ converter.linearHangul(converter.dayOfWeekHanhulWithIndex("Mon")));
		System.out.println(" ");
	}
}
