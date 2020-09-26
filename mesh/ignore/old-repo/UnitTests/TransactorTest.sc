TestUpdate : UnitTest {
	var update;

	setUp {
		update = Update.new();
	}

	tearDown {
	}

	test_Update{
		this.updateIsUpdate;
  }

	updateIsUpdate{
		this.assert(update.isKindOf(Update), "update is an Update")
  }

}
