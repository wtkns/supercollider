TestKhora : UnitTest {

	setUp {
	}

	tearDown {
	}

	test_khora{
		var number = 6;
		this.makeKhora(number);
		this.freeAll;
	}


	freeAll{
		// Mesh.freeAll;
		this.classInitialized;
	}

	makeKhora{|key = (this.nextNewName)|
		var khora = Khora.new(key);
		^ khora;
	}

}
