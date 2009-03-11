# Rails Callendar Component
# Copyright (C) 2006 Craig Ambrose
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

class Calendar::ComponentController < ApplicationController
  include PortallusComponent
  uses_component_template_root
  layout nil

  def index
    active_section
    @can_administer = can_administer?

    start_date = last_monday

    load_weeks(start_date, calendar_end_date)
  end

  def show
    index
    render(:action => 'index')
  end

  def event
    @event = current_event
    @can_administer = can_administer?
    active_section
  end

  def delete
    unless can_administer?
      redirect_to_section_home
      return
    end

    current_event.destroy
    redirect_to_section_home
  end

  def edit
    unless can_administer?
      redirect_to_section_home
      return
    end

    @event = current_event
    @current_link =  active_section.to_param + '/edit/' + @event.to_param.to_s

    if request.post? and @event.update_attributes(@params[:event])
      redirect_to(:action => 'show', :name => active_section.to_param + "/event/" + @event.id.to_s)
    end
  end

  def display_form
    if !can_administer?
      render(:action => "hide_form")
      return
    end
    @can_administer = can_administer?
    @current_link =  active_section.to_param + '/create/'

    @event = Event.new
  end

  def hide_form
  end

  def create
    if !can_administer?
      render(:action => "hide_form")
      return
    end
    @can_administer = can_administer?
    @current_link =  active_section.to_param + '/create/'

    @event = Event.new(@params[:event])
    @event.event_set = event_set

    if @event.save
      @saved = true
      load_event(@event, calendar_start_date, calendar_end_date)
    end
  end

  def display_event_summary
    @id = @params[:name]
    event_summary
  end

  def event_summary
    @event = current_event
  end

private

  def load_event(event, start_date, end_date)
    @previous_events = Hash.new
    @insert_dates = event.all_dates_between(start_date, end_date)

    event.all_dates.each do |event_date|
      @previous_events[event_date] = event_before(event_date, event)
    end
  end

  def trim_dates(date_array, start_date, end_date)
    result = Array.new

    date_array.each do |date|
      result << date if date.start
    end
  end

  def event_before(date, search_event)
    events_on_date(date).reverse_each do |event|
      return event if event.start_time < search_event.start_time
    end
    nil
  end

  def events_on_date(date)
    event_set.all_events_between_dates(date, date)
  end

  def load_weeks(start_date, end_date)
    @weeks = Array.new

    week_start = start_date
    week_index = 0
    while week_start < end_date
      @weeks[week_index] = date_range(start_date, week_index, 7)

      week_start += 7
      week_index += 1
    end

    @events = events(start_date, end_date)
  end

  def current_event
    event_set.find_event(@params[:name])
  end

  def events(start_date, end_date)
    result = Hash.new
    event_set.all_events_between_dates(start_date, end_date).each do |event|
      event.all_dates.each do |event_date|
        result[event_date] = Array.new if result[event_date] == nil
        result[event_date] << event
      end
    end

    result
  end

  def event_set
    @event_set = EventSet.find(:first, :conditions => ["section_id = ?", active_section.id]) if @event_set == nil
    create_event_set if @event_set == nil
    @event_set
  end

  def create_event_set
    @event_set = EventSet.new
    @event_set.section = active_section
    @event_set.create
    @event_set
  end

  def date_range(start, offset, length)
    day_offset = offset * length
    (start + day_offset)..(start + day_offset + (length - 1))
  end

  def calendar_start_date
    last_monday
  end

  def calendar_end_date
    if desired_month != nil || desired_year != nil
      @desired_end = @desired_start >> 1
      @desired_end -= 1
    else
      @desired_end = last_monday + (7 * 4)
    end
    return @desired_end
  end

  def desired_month
    @params['value1'] == nil ? nil : @params['value1'].to_i
  end

  def desired_year
    @params[:name] == nil ? nil : @params[:name].to_i
  end

  def last_monday
    if desired_month != nil && desired_year != nil
      @desired_start = Date.new(desired_year, desired_month, 1)
    else
      @desired_start = Date.today
    end

    Date.neww(@desired_start.year, @desired_start.cweek, 1)
  end


end
