
#
# specifying raabro
#
# Sun Sep 20 06:11:54 JST 2015
#

require 'spec_helper'


describe Raabro do

  describe '.seq' do

    before :each do

      @input = Raabro::Input.new('tato')
    end

    it "returns a tree with result == 0 in case of failure" do

      t = Raabro.seq(nil, @input, :to, :ta)

      expect(t.to_a).to eq(
        [ nil, 0, 0, 0, nil, :seq, [
          [ nil, 0, 0, 0, nil, :str, [] ]
        ] ]
      )
      expect(@input.offset).to eq(0)
    end

    it "returns a tree with result == 0 in case of failure (at 2nd step)" do

      t = Raabro.seq(nil, @input, :ta, :ta)

      expect(
        t.to_a(:leaves => true)
      ).to eq(
        [ nil, 0, 0, 0, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ],
          [ nil, 0, 2, 0, nil, :str, [] ]
        ] ]
      )
      expect(@input.offset).to eq(0)
    end

    it "returns a tree with result == 1 in case of success" do

      t = Raabro.seq(nil, @input, :ta, :to)

      expect(
        t.to_a(:leaves => true)
      ).to eq(
        [ nil, 1, 0, 4, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ]
        ] ]
      )
      expect(@input.offset).to eq(4)
    end
  end
end

#describe "fabr_seq()"
#{
#  before each
#  {
#    fabr_input i = { "tato", 0, 0 };
#    fabr_tree *t = NULL;
#  }
#  after each
#  {
#    fabr_tree_free(t);
#  }
#
#  fabr_tree *_ta(fabr_input *i) { return fabr_str(NULL, i, "ta"); }
#  fabr_tree *_to(fabr_input *i) { return fabr_str(NULL, i, "to"); }
#
#  it "returns a tree with result == 0 in case of failure"
#  it "returns a tree with result == 0 in case of failure (at 2nd step)"
#
#  it "returns a tree with result == 1 in case of success"
#  {
#    t = fabr_seq(NULL, &i, _ta, _to, NULL);
#
#    expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#      "[ null, 1, 0, 4, null, \"seq\", 0, [\n"
#      "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#      "  [ null, 1, 2, 2, null, \"str\", 2, \"to\" ]\n"
#      "] ]");
#  }
#
#  it "names the result if there is a name"
#  {
#    t = fabr_seq("x", &i, _ta, _to, NULL);
#
#    expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#      "[ \"x\", 1, 0, 4, null, \"seq\", 0, [\n"
#      "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#      "  [ null, 1, 2, 2, null, \"str\", 2, \"to\" ]\n"
#      "] ]");
#  }
#
#  it "names in case of failure as well"
#  {
#    t = fabr_seq("x", &i, _to, _ta, NULL);
#
#    expect(fabr_tree_to_string(t, NULL, 0) ===f ""
#      "[ \"x\", 0, 0, 0, null, \"seq\", 0, [\n"
#      "  [ null, 0, 0, 0, null, \"str\", 2, [] ]\n"
#      "] ]");
#  }
#
#  it "fails when the input string ends"
#  {
#    i.string = "to";
#    t = fabr_seq("x", &i, _to, _ta, NULL);
#
#    expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#      "[ \"x\", 0, 0, 0, null, \"seq\", 0, [\n"
#      "  [ null, 1, 0, 2, null, \"str\", 2, \"to\" ],\n"
#      "  [ null, 0, 2, 0, null, \"str\", 2, [] ]\n"
#      "] ]");
#  }
#
#  it "resets the input offset in case of failure"
#  {
#    i.string = "totita";
#    t = fabr_seq("x", &i, _to, _ta, NULL);
#
#    expect(t->result i== 0);
#    expect(t->length zu== 0);
#    expect(i.offset zu== 0);
#  }
#
#  it "accepts an empty input"
#  {
#    i.string = "t0t0";
#    i.offset = 4;
#
#    t = fabr_seq("z", &i, _to, _ta, NULL);
#
#    ensure(fabr_tree_to_string(t, NULL, 0) ===f ""
#      "[ \"z\", 0, 4, 0, null, \"seq\", 0, [\n"
#      "  [ null, 0, 4, 0, null, \"str\", 2, [] ]\n"
#      "] ]");
#  }
#
#  context "quantifiers"
#  {
#    describe "a lonely quantifier"
#    {
#      it "triggers an error"
#      {
#        i.string = "tatota";
#        t = fabr_seq("y", &i, fabr_qmark, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"y\", -1, 0, 0, \"bad position for fabr_qmark, _star or _plus\", \"seq\", 0, [] ]");
#      }
#    }
#
#    describe "fabr_qmark"
#    {
#      it "fails"
#      {
#        i.string = "tatotota";
#        t = fabr_seq("x", &i, _ta, _to, fabr_qmark, _ta, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"x\", 0, 0, 0, null, \"seq\", 0, [\n"
#          "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#          "  [ null, 1, 2, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 0, 4, 0, null, \"str\", 2, [] ]\n"
#          "] ]");
#      }
#
#      it "succeeds"
#      {
#        i.string = "tata";
#        t = fabr_seq("y", &i, _ta, _to, fabr_qmark, _ta, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"y\", 1, 0, 4, null, \"seq\", 0, [\n"
#          "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#          "  [ null, 0, 2, 0, null, \"str\", 2, [] ],\n"
#          "  [ null, 1, 2, 2, null, \"str\", 2, \"ta\" ]\n"
#          "] ]");
#      }
#
#      it "succeeds (2)"
#      {
#        i.string = "tatota";
#        t = fabr_seq("z", &i, _ta, _to, fabr_qmark, _ta, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"z\", 1, 0, 6, null, \"seq\", 0, [\n"
#          "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#          "  [ null, 1, 2, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 1, 4, 2, null, \"str\", 2, \"ta\" ]\n"
#          "] ]");
#      }
#
#      it "prunes when input->flags & FABR_F_PRUNE"
#      {
#        i.string = "tatota";
#        i.flags = FABR_F_PRUNE;
#
#        t = fabr_seq("z", &i, _ta, _to, fabr_qmark, _ta, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"z\", 1, 0, 6, null, \"seq\", 0, [\n"
#          "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#          "  [ null, 1, 2, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 1, 4, 2, null, \"str\", 2, \"ta\" ]\n"
#          "] ]");
#      }
#    }
#
#    describe "fabr_star"
#    {
#      it "succeeds"
#      {
#        i.string = "tata";
#        t = fabr_seq("x", &i, _ta, _to, fabr_star, _ta, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"x\", 1, 0, 4, null, \"seq\", 0, [\n"
#          "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#          "  [ null, 0, 2, 0, null, \"str\", 2, [] ],\n"
#          "  [ null, 1, 2, 2, null, \"str\", 2, \"ta\" ]\n"
#          "] ]");
#      }
#
#      it "succeeds (2)"
#      {
#        i.string = "tatotota";
#        t = fabr_seq("x", &i, _ta, _to, fabr_star, _ta, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"x\", 1, 0, 8, null, \"seq\", 0, [\n"
#          "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#          "  [ null, 1, 2, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 1, 4, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 0, 6, 0, null, \"str\", 2, [] ],\n"
#          "  [ null, 1, 6, 2, null, \"str\", 2, \"ta\" ]\n"
#          "] ]");
#      }
#
#      it "prunes when input->flags & FABR_F_PRUNE"
#      {
#        i.string = "tatotota";
#        i.flags = FABR_F_PRUNE;
#
#        t = fabr_seq("x", &i, _ta, _to, fabr_star, _ta, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"x\", 1, 0, 8, null, \"seq\", 0, [\n"
#          "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#          "  [ null, 1, 2, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 1, 4, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 1, 6, 2, null, \"str\", 2, \"ta\" ]\n"
#          "] ]");
#      }
#    }
#
#    describe "fabr_plus"
#    {
#      it "fails"
#      {
#        i.string = "tata";
#        t = fabr_seq("x", &i, _ta, _to, fabr_plus, _ta, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"x\", 0, 0, 0, null, \"seq\", 0, [\n"
#          "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#          "  [ null, 0, 2, 0, null, \"str\", 2, [] ]\n"
#          "] ]");
#      }
#
#      it "succeeds"
#      {
#        i.string = "tatotota";
#        t = fabr_seq("x", &i, _ta, _to, fabr_plus, _ta, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"x\", 1, 0, 8, null, \"seq\", 0, [\n"
#          "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#          "  [ null, 1, 2, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 1, 4, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 0, 6, 0, null, \"str\", 2, [] ],\n"
#          "  [ null, 1, 6, 2, null, \"str\", 2, \"ta\" ]\n"
#          "] ]");
#      }
#
#      it "prunes when input->flags & FABR_F_PRUNE"
#      {
#        i.string = "tatotota";
#        i.flags = FABR_F_PRUNE;
#
#        t = fabr_seq("x", &i, _ta, _to, fabr_plus, _ta, NULL);
#
#        expect(fabr_tree_to_string(t, i.string, 0) ===f ""
#          "[ \"x\", 1, 0, 8, null, \"seq\", 0, [\n"
#          "  [ null, 1, 0, 2, null, \"str\", 2, \"ta\" ],\n"
#          "  [ null, 1, 2, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 1, 4, 2, null, \"str\", 2, \"to\" ],\n"
#          "  [ null, 1, 6, 2, null, \"str\", 2, \"ta\" ]\n"
#          "] ]");
#      }
#    }
#  }
#}

