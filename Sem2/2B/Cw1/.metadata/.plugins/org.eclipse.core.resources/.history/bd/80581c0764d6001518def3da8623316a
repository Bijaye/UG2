package matcher;

public class StudentClass {

	private String text;
	private String pattern;
	private int textLen;
	private int patternLen;
	private int[] prefixFunction;
	private Queue matchIndices;
	
	public StudentClass(String text, String pattern) {
		this.text = text;
		this.pattern = pattern;
		this.textLen = text.length();
		this.patternLen = pattern.length();
		this.prefixFunction = new int[patternLen + 1];
		this.matchIndices = new Queue();
	}
	
	public int[] getPrefixFunction() {
		return prefixFunction;
	}
	
	public void buildPrefixFunction() {
		prefixFunction = ComputePrexFunction(pattern);
	}

	public Queue getMatchIndices() {
		return matchIndices;
	}
	
	public void search() {
		matchIndices = KMPMatcher(text, pattern);
	}
	
	public static int[] ComputePrexFunction(String P) {
		// Please add your code here.
	}
	
	public static Queue KMPMatcher(String T, String P) {
		// Please add your code here.
	}
}