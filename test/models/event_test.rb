require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'many opens' do
    Event.create kind: 'opening',
                 starts_at: DateTime.parse('2014-08-04 13:00').in_time_zone,
                 ends_at: DateTime.parse('2014-08-04 18:30').in_time_zone,
                 weekly_recurring: true

    availabilities = Event.availabilities DateTime.parse('2014-08-10')

    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ['13:00', '13:30','14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30', '18:00'], availabilities[1][:slots]
    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test 'many rdvs' do
    Event.create kind: 'opening',
                 starts_at: DateTime.parse('2014-08-04 10:00').in_time_zone,
                 ends_at: DateTime.parse('2014-08-04 18:30').in_time_zone,
                 weekly_recurring: true

    Event.create kind: 'appointment',
                 starts_at: DateTime.parse('2014-08-11 15:30').in_time_zone,
                 ends_at: DateTime.parse('2014-08-11 16:30').in_time_zone

    availabilities = Event.availabilities DateTime.parse('2014-08-10')

    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]

    expected_slots = ['10:00', '10:30', '11:00', '11:30', '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '16:30', '17:00', '17:30', '18:00']
    assert_equal expected_slots, availabilities[1][:slots]
    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "one simple test example" do

    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]
    assert_equal [], availabilities[2][:slots]
    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal 7, availabilities.length
  end
end
